document.querySelectorAll("[data-answer-toggle]").forEach((button) => {
  const answers = Array.from(document.querySelectorAll("#main-content div")).filter(
    (element) =>
      Array.from(element.children).some(
        (child) =>
          child.tagName === "STRONG" &&
          child.textContent.trim().toLowerCase() === "mijn antwoord:",
      ),
  );
  const status = button.parentElement.querySelector("[data-answer-status]");

  if (answers.length === 0) {
    button.disabled = true;
    status.textContent = "Er staan geen antwoordvakken op deze pagina.";
    return;
  }

  button.addEventListener("click", () => {
    const hidden = button.getAttribute("aria-pressed") !== "true";

    answers.forEach((answer) => {
      answer.hidden = hidden;
    });
    button.setAttribute("aria-pressed", String(hidden));
    button.textContent = hidden ? "Toon antwoorden" : "Verberg antwoorden";
    status.textContent = hidden ? "De antwoorden zijn verborgen." : "De antwoorden zijn zichtbaar.";
  });
});
