const searchScript = document.currentScript;
const siteRoot = new URL("../index.html", searchScript.src);
const sitePath = siteRoot.pathname.slice(0, siteRoot.pathname.lastIndexOf("/") + 1);
const searchBar = document.createElement("section");
searchBar.className = "site-search";
searchBar.innerHTML = `
  <form class="site-search-form" role="search">
    <label for="site-search-input">Doorzoek de volledige website</label>
    <div class="site-search-controls">
      <input id="site-search-input" type="search" autocomplete="off" placeholder="Zoek een woord of PowerShell-commando" />
      <button type="submit">Zoeken</button>
    </div>
  </form>
  <div class="site-search-results" hidden>
    <p class="site-search-status" role="status" aria-live="polite"></p>
    <ol class="site-search-list"></ol>
  </div>
`;

document.querySelector(".docs-header").after(searchBar);

const searchForm = searchBar.querySelector(".site-search-form");
const searchInput = searchBar.querySelector("#site-search-input");
const searchResults = searchBar.querySelector(".site-search-results");
const searchStatus = searchBar.querySelector(".site-search-status");
const searchList = searchBar.querySelector(".site-search-list");
let indexPromise;
let debounceTimer;

const normalizedText = (value) => value.replace(/\s+/g, " ").trim();

const assignHeadingIds = (pageDocument) => {
  const usedIds = new Set(
    Array.from(pageDocument.querySelectorAll("[id]"), (element) => element.id),
  );
  const headings = Array.from(
    pageDocument.querySelectorAll("#main-content h1, #main-content h2, #main-content h3, #main-content h4, #main-content h5, #main-content h6"),
  );
  const headingsByPriority = [
    ...headings.filter((heading) => heading.tagName === "H2"),
    ...headings.filter((heading) => heading.tagName !== "H2"),
  ];

  headingsByPriority.forEach((heading) => {
    if (heading.id) {
      return;
    }

    const baseId = heading.textContent
      .trim()
      .toLowerCase()
      .normalize("NFD")
      .replace(/[\u0300-\u036f]/g, "")
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-|-$/g, "") || "section";
    let id = baseId;
    let suffix = 2;

    while (usedIds.has(id)) {
      id = `${baseId}-${suffix}`;
      suffix += 1;
    }

    heading.id = id;
    usedIds.add(id);
  });
};

assignHeadingIds(document);

const createPageRecords = (documentPage, pageUrl) => {
  assignHeadingIds(documentPage);
  const main = documentPage.querySelector("main") || documentPage.body;
  const pageTitle = normalizedText(documentPage.title);
  const imageDescriptions = Array.from(main.querySelectorAll("img[alt]"))
    .map((image) => image.alt)
    .filter(Boolean)
    .join(" ");
  const headings = Array.from(main.querySelectorAll("h1, h2, h3, h4, h5, h6"));

  if (headings.length === 0) {
    return [{
      title: pageTitle || pageUrl.pathname.split("/").pop(),
      href: pageUrl.href,
      content: normalizedText(main.textContent + " " + imageDescriptions),
      pageTitle,
      isFirstOnPage: true,
      kind: "Pagina",
    }];
  }

  return headings.map((heading, index) => {
    const nextHeading = headings[index + 1];
    const range = documentPage.createRange();
    range.setStartAfter(heading);
    if (nextHeading) {
      range.setEndBefore(nextHeading);
    } else {
      range.setEndAfter(main.lastChild || heading);
    }

    const headingText = normalizedText(heading.textContent);
    const sectionText = normalizedText(range.toString());
    const anchor = heading.id ? `#${encodeURIComponent(heading.id)}` : "";

    return {
      title: `${pageTitle} — ${headingText}`,
      href: `${pageUrl.href}${anchor}`,
      content: normalizedText(`${headingText} ${sectionText} ${index === 0 ? imageDescriptions : ""}`),
      pageTitle,
      headingText,
      isFirstOnPage: index === 0,
      kind: "Pagina",
    };
  });
};

const isAllowedSource = (url) =>
  url.origin === siteRoot.origin &&
  url.pathname.startsWith(sitePath) &&
  /\.(html|ps1|txt)$/i.test(url.pathname);

const loadSearchIndex = async () => {
  const pending = [siteRoot];
  const visited = new Set();
  const records = [];
  const failures = [];

  while (pending.length > 0) {
    const batch = [];
    while (pending.length > 0 && batch.length < 5) {
      const sourceUrl = pending.shift();
      sourceUrl.hash = "";
      sourceUrl.search = "";
      if (!isAllowedSource(sourceUrl) || visited.has(sourceUrl.href)) {
        continue;
      }

      visited.add(sourceUrl.href);
      batch.push(sourceUrl);
    }

    const loadedSources = await Promise.all(batch.map(async (sourceUrl) => {
      try {
        const response = await fetch(sourceUrl.href);
        if (!response.ok) {
          throw new Error(`HTTP ${response.status}`);
        }

        return { sourceUrl, content: await response.text() };
      } catch (error) {
        failures.push(`${sourceUrl.pathname}: ${error.message}`);
        return null;
      }
    }));

    loadedSources.filter(Boolean).forEach(({ sourceUrl, content }) => {
      if (/\.html$/i.test(sourceUrl.pathname)) {
        const parsedPage = new DOMParser().parseFromString(content, "text/html");
        records.push(...createPageRecords(parsedPage, sourceUrl));

        parsedPage.querySelectorAll("a[href], iframe[src]").forEach((link) => {
          const target = new URL(
            link.getAttribute("href") || link.getAttribute("src"),
            sourceUrl,
          );
          target.hash = "";
          target.search = "";
          if (isAllowedSource(target) && !visited.has(target.href)) {
            pending.push(target);
          }
        });
        return;
      }

      const filename = decodeURIComponent(sourceUrl.pathname.split("/").pop());
      records.push({
        title: filename,
        href: sourceUrl.href,
        content: normalizedText(`${filename} ${content}`),
        kind: /\.ps1$/i.test(sourceUrl.pathname) ? "PowerShell-script" : "Tekstbestand",
      });
    });
  }

  if (records.length === 0) {
    throw new Error("Er konden geen websitepagina's of bestanden worden geladen.");
  }

  return { records, failures };
};

const matchingRecords = (records, query) => {
  const terms = query.toLowerCase().split(/\s+/).filter(Boolean);

  return records
    .map((record) => {
      const searchableText = record.content.toLowerCase();
      const contentMatches = terms.every((term) => searchableText.includes(term));
      const pageTitleMatches =
        record.kind === "Pagina" &&
        record.isFirstOnPage &&
        terms.every((term) => record.pageTitle.toLowerCase().includes(term));
      if (!contentMatches && !pageTitleMatches) {
        return null;
      }

      const phraseMatch = searchableText.includes(query.toLowerCase());
      const headingMatches = terms.filter((term) =>
        record.headingText?.toLowerCase().includes(term),
      ).length;
      return { ...record, score: headingMatches + Number(phraseMatch) * 2 };
    })
    .filter(Boolean)
    .sort((first, second) => second.score - first.score || first.title.localeCompare(second.title));
};

const createExcerpt = (content, query) => {
  const terms = query.toLocaleLowerCase().split(/\s+/).filter(Boolean);
  const lowerContent = content.toLocaleLowerCase();
  const matchPosition = Math.max(0, lowerContent.indexOf(terms[0]));
  const start = Math.max(0, matchPosition - 100);
  const end = Math.min(content.length, matchPosition + 220);
  return `${start > 0 ? "… " : ""}${content.slice(start, end)}${end < content.length ? " …" : ""}`;
};

const renderResults = (records, query, failures) => {
  const matches = matchingRecords(records, query);
  const visibleMatches = matches.slice(0, 50);
  searchList.replaceChildren();

  if (visibleMatches.length === 0) {
    searchStatus.textContent = `Geen resultaten voor “${query}”.`;
  } else {
    const resultLabel = matches.length === 1 ? "resultaat" : "resultaten";
    const extraResults = matches.length > visibleMatches.length
      ? ` De eerste ${visibleMatches.length} resultaten worden getoond.`
      : "";
    searchStatus.textContent = `${matches.length} ${resultLabel} voor “${query}”.${extraResults}`;
  }

  if (failures.length > 0) {
    const failureLabel = failures.length === 1 ? "bron" : "bronnen";
    const failureVerb = failures.length === 1 ? "kon" : "konden";
    searchStatus.textContent += ` ${failures.length} ${failureLabel} ${failureVerb} niet worden geladen: ${failures.join("; ")}`;
  }

  visibleMatches.forEach((match, index) => {
    const item = document.createElement("li");
    item.className = "site-search-result";

    const resultHeading = document.createElement("div");
    resultHeading.className = "site-search-result-heading";

    const resultLink = document.createElement("a");
    resultLink.href = match.href;
    resultLink.textContent = match.title;

    const previewButton = document.createElement("button");
    previewButton.type = "button";
    previewButton.className = "site-search-preview-toggle";
    previewButton.textContent = "Voorbeeld";
    previewButton.setAttribute("aria-expanded", "false");

    const preview = document.createElement("pre");
    preview.className = "site-search-preview";
    preview.id = `site-search-preview-${index}`;
    preview.hidden = true;
    const resultExcerpt = document.createElement("p");
    resultExcerpt.className = "site-search-result-excerpt";
    resultExcerpt.textContent = createExcerpt(match.content, query);

    previewButton.setAttribute("aria-controls", preview.id);

    previewButton.addEventListener("click", () => {
      const expanded = preview.hidden;
      if (expanded) {
        preview.textContent = match.content;
      }
      preview.hidden = !expanded;
      previewButton.setAttribute("aria-expanded", String(expanded));
      previewButton.textContent = expanded ? "Voorbeeld verbergen" : "Voorbeeld";
    });

    const resultMeta = document.createElement("p");
    resultMeta.className = "site-search-result-meta";
    resultMeta.textContent = `${match.kind} · ${new URL(match.href).pathname.slice(sitePath.length)}`;

    resultHeading.append(resultLink, previewButton);
    item.append(resultHeading, resultMeta, resultExcerpt, preview);
    searchList.append(item);
  });
};

const search = async () => {
  const query = normalizedText(searchInput.value);
  if (!query) {
    searchResults.hidden = true;
    searchList.replaceChildren();
    return;
  }

  searchResults.hidden = false;
  searchStatus.textContent = "De website wordt doorzocht...";
  searchList.replaceChildren();

  try {
    indexPromise ||= loadSearchIndex();
    const { records, failures } = await indexPromise;
    if (normalizedText(searchInput.value) !== query) {
      return;
    }

    renderResults(records, query, failures);
  } catch (error) {
    indexPromise = undefined;
    if (normalizedText(searchInput.value) === query) {
      searchStatus.textContent = `Zoeken is niet gelukt: ${error.message}`;
    }
  }
};

searchForm.addEventListener("submit", (event) => {
  event.preventDefault();
  window.clearTimeout(debounceTimer);
  search();
});

searchInput.addEventListener("input", () => {
  window.clearTimeout(debounceTimer);
  debounceTimer = window.setTimeout(search, 250);
});

document.addEventListener("keydown", (event) => {
  if (event.key === "Escape" && !searchResults.hidden) {
    searchResults.hidden = true;
    searchInput.blur();
  }
});

document.addEventListener("click", (event) => {
  if (!searchBar.contains(event.target)) {
    searchResults.hidden = true;
  }
});
