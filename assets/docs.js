const findBoxes = (label) =>
  Array.from(document.querySelectorAll("#main-content div")).filter((element) =>
    Array.from(element.children).some(
      (child) =>
        child.tagName === "STRONG" &&
        child.textContent.trim().toLowerCase() === label,
    ),
  );

const answerSectionHeading = Array.from(
  document.querySelectorAll(".docs-sidebar .sidebar-group-label"),
).find((heading) =>
  ["op deze pagina", "onderdelen"].includes(
    heading.textContent.trim().toLowerCase(),
  ),
);

let lastControls = answerSectionHeading;

const setupAnswerToggles = ({
  label,
  idPrefix,
  showAll,
  hideAll,
  showOne,
  hideOne,
  noun,
}) => {
  const answers = findBoxes(label);

  if (answers.length === 0 || !lastControls) {
    return;
  }

  const answerControls = document.createElement("div");
  answerControls.className = "answer-controls";

  const allAnswersToggle = document.createElement("button");
  allAnswersToggle.className = "answer-toggle";
  allAnswersToggle.type = "button";
  allAnswersToggle.textContent = showAll;

  const answerStatus = document.createElement("span");
  answerStatus.className = "answer-toggle-status";
  answerStatus.setAttribute("role", "status");
  answerStatus.setAttribute("aria-live", "polite");

  answerControls.append(allAnswersToggle, answerStatus);
  lastControls.after(answerControls);
  lastControls = answerControls;

  const updateAnswerControls = () => {
    const visibleAnswers = answers.filter((answer) => !answer.hidden).length;
    const allAnswersVisible = visibleAnswers === answers.length;

    allAnswersToggle.textContent = allAnswersVisible ? hideAll : showAll;

    if (visibleAnswers === 0) {
      answerStatus.textContent = `Alle ${noun} zijn verborgen.`;
    } else if (allAnswersVisible) {
      answerStatus.textContent = `Alle ${noun} zijn zichtbaar.`;
    } else {
      answerStatus.textContent = `${visibleAnswers} van de ${answers.length} ${noun} zijn zichtbaar.`;
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
    let answerId = `${idPrefix}-${index + 1}`;
    let suffix = 2;

    while (document.getElementById(answerId)) {
      answerId = `${idPrefix}-${index + 1}-${suffix}`;
      suffix += 1;
    }

    answer.id = answerId;
    answer.hidden = true;

    const button = document.createElement("button");
    button.className = "answer-toggle";
    button.type = "button";
    button.setAttribute("aria-controls", answerId);
    button.setAttribute("aria-expanded", "false");
    button.textContent = showOne;

    button.addEventListener("click", () => {
      const expanded = answer.hidden;
      answer.hidden = !expanded;
      button.setAttribute("aria-expanded", String(expanded));
      button.textContent = expanded ? hideOne : showOne;
      updateAnswerControls();
    });

    answer.before(button);
  });

  updateAnswerControls();
};

setupAnswerToggles({
  label: "mijn antwoord:",
  idPrefix: "answer",
  showAll: "Toon antwoorden",
  hideAll: "Verberg antwoorden",
  showOne: "Antwoord",
  hideOne: "Verberg antwoord",
  noun: "antwoorden",
});

setupAnswerToggles({
  label: "geavanceerd antwoord:",
  idPrefix: "advanced-answer",
  showAll: "Toon Geavanceerde Antwoorden",
  hideAll: "Verberg Geavanceerde Antwoorden",
  showOne: "Geavanceerd antwoord",
  hideOne: "Verberg geavanceerd antwoord",
  noun: "geavanceerde antwoorden",
});
