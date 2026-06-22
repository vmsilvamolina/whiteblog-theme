const copyButtonSVG = `<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#FAFAFA" class="bi bi-copy" viewBox="0 0 16 16">
  <path fill-rule="evenodd" d="M4 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v8a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2zm2-1a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1zM2 5a1 1 0 0 0-1 1v8a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-1h1v1a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h1v1z"/>
</svg>`;

const checkmarkSVG = `Copied <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-check-lg" viewBox="0 0 16 16">
  <path d="M12.736 3.97a.733.733 0 0 1 1.047 0c.286.289.29.756.01 1.05L7.88 12.01a.733.733 0 0 1-1.065.02L3.217 8.384a.757.757 0 0 1 0-1.06.733.733 0 0 1 1.047 0l3.052 3.093 5.4-6.425z"/>
</svg>`;

if (navigator.clipboard) {
  document.querySelectorAll("pre").forEach((block) => {
    const button = document.createElement("button");
    button.innerHTML = copyButtonSVG;
    button.setAttribute("aria-label", "Copiar código");
    button.classList.add("copy-btn");
    block.style.position = "relative";
    block.appendChild(button);
  });

  document.addEventListener("click", async (e) => {
    const button = e.target.closest(".copy-btn");
    if (!button) return;
    const block = button.closest("pre");
    if (block) await copyCode(block, button);
  });
}

async function copyCode(block, button) {
  let code = block.querySelector("code");
  let text = code.innerText;

  try {
    await navigator.clipboard.writeText(text);
    button.innerHTML = checkmarkSVG;
    button.setAttribute("aria-label", "Copiado");
    button.classList.add("copy-success");

    setTimeout(() => {
      button.innerHTML = copyButtonSVG;
      button.setAttribute("aria-label", "Copiar código");
      button.classList.remove("copy-success");
    }, 1000);
  } catch (err) {
    button.innerHTML = "Error";
    setTimeout(() => { button.innerHTML = copyButtonSVG; }, 1500);
  }
}

let mainNav = document.getElementById("js-menu");
let navBarToggle = document.getElementById("js-nav-toggle");

if (navBarToggle) {
  navBarToggle.addEventListener("click", function() {
    const isExpanded = mainNav.classList.toggle("active");
    navBarToggle.setAttribute("aria-expanded", isExpanded);
  });
}

document.addEventListener("keydown", function(e) {
  if (e.key === "Escape" && mainNav && mainNav.classList.contains("active")) {
    mainNav.classList.remove("active");
    if (navBarToggle) {
      navBarToggle.setAttribute("aria-expanded", "false");
      navBarToggle.focus();
    }
  }
});
