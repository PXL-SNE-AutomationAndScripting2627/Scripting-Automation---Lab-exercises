const answers = Array.from(document.querySelectorAll("#main-content div")).filter(
  (element) =>
    Array.from(element.children).some(
      (child) =>
        child.tagName === "STRONG" &&
        child.textContent.trim().toLowerCase() === "mijn antwoord:",
    ),
);

const answerControls = document.createElement("div");
answerControls.className = "answer-controls";

const allAnswersToggle = document.createElement("button");
allAnswersToggle.className = "answer-toggle";
allAnswersToggle.type = "button";
allAnswersToggle.textContent = "Toon antwoorden";

const answerStatus = document.createElement("span");
answerStatus.className = "answer-toggle-status";
answerStatus.setAttribute("role", "status");
answerStatus.setAttribute("aria-live", "polite");

answerControls.append(allAnswersToggle, answerStatus);
const answerSectionHeading = Array.from(
  document.querySelectorAll(".docs-sidebar .sidebar-group-label"),
).find((heading) =>
  ["op deze pagina", "onderdelen"].includes(
    heading.textContent.trim().toLowerCase(),
  ),
);
answerSectionHeading.after(answerControls);

const updateAnswerControls = () => {
  const visibleAnswers = answers.filter((answer) => !answer.hidden).length;
  const allAnswersVisible = visibleAnswers === answers.length;

  allAnswersToggle.textContent = allAnswersVisible
    ? "Verberg antwoorden"
    : "Toon antwoorden";

  if (visibleAnswers === 0) {
    answerStatus.textContent = "Alle antwoorden zijn verborgen.";
  } else if (allAnswersVisible) {
    answerStatus.textContent = "Alle antwoorden zijn zichtbaar.";
  } else {
    answerStatus.textContent = `${visibleAnswers} van de ${answers.length} antwoorden zijn zichtbaar.`;
  }
};

allAnswersToggle.addEventListener("click", () => {
  const showAnswers = answers.some((answer) => answer.hidden);

  answers.forEach((answer) => {
    answer.hidden = !showAnswers;
  });
  updateAnswerControls();
});

answers.forEach((answer, index) => {
  let answerId = `answer-${index + 1}`;
  let suffix = 2;

  while (document.getElementById(answerId)) {
    answerId = `answer-${index + 1}-${suffix}`;
    suffix += 1;
  }

  answer.id = answerId;
  answer.hidden = true;

  const button = document.createElement("button");
  button.className = "answer-toggle";
  button.type = "button";
  button.setAttribute("aria-controls", answerId);
  button.setAttribute("aria-expanded", "false");
  button.textContent = "Antwoord";

  button.addEventListener("click", () => {
    const expanded = answer.hidden;
    answer.hidden = !expanded;
    button.setAttribute("aria-expanded", String(expanded));
    button.textContent = expanded ? "Verberg antwoord" : "Antwoord";
    updateAnswerControls();
  });

  answer.before(button);
});

updateAnswerControls();
