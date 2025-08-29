document.addEventListener("DOMContentLoaded", () => {
  // Xử lý các thẻ <code> rỗng
  document.querySelectorAll("code").forEach(codeBlock => {
    if (codeBlock.innerText.trim() === "") {
      codeBlock.textContent = "Coming soon!";

      const pre = codeBlock.closest("pre");
      if (pre) {
        pre.style.display = "flex";
        pre.style.justifyContent = "center";
        pre.style.padding = "1rem"
        pre.style.fontSize = "1rem"
      }
    }
  });

  // Click vào <pre> để copy
  document.querySelectorAll("pre").forEach(pre => {
    pre.addEventListener("click", () => {
      const codeBlock = pre.querySelector("code");
      if (!codeBlock) return;

      const code = codeBlock.innerText;

      const textarea = document.createElement("textarea");
      textarea.value = code;
      textarea.setAttribute("readonly", "");
      textarea.style.position = "absolute";
      textarea.style.left = "-9999px";
      document.body.appendChild(textarea);

      textarea.select();
      const success = document.execCommand("copy");
      document.body.removeChild(textarea);

      if (success) {
        showPopup("✓ Copied!");
      } else {
        showPopup("❌ Failed");
      }
    });
  });

  // Hàm tạo popup thông báo
  function showPopup(message) {
    const popup = document.createElement("div");
    popup.textContent = message;
    popup.style.position = "fixed";
    popup.style.bottom = "20px";
    popup.style.left = "50%";
    popup.style.transform = "translateX(-50%)";
    popup.style.background = "linear-gradient(45deg, #FF0000, #FF7F00, #FFFF00, #00FF00, #0000FF, #4B0082, #8B00FF, #000000)";
    popup.style.backgroundSize = "400% 400%";
    popup.style.color = "#fff";
    popup.style.padding = "10px 20px";
    popup.style.borderRadius = "20px";
    popup.style.fontWeight = "bold";
    popup.style.fontSize = "14px";
    popup.style.boxShadow = "0 4px 10px rgba(0,0,0,0.3)";
    popup.style.animation = "rainbow 8s linear infinite, fadeout 4s forwards";

    document.body.appendChild(popup);

    setTimeout(() => {
      popup.remove();
    }, 8000);
  }

  // Thêm keyframes cho hiệu ứng rainbow
  const style = document.createElement("style");
  style.textContent = `
    @keyframes rainbow {
      0% {background-position:0% 50%}
      50% {background-position:100% 50%}
      100% {background-position:0% 50%}
    }
    @keyframes fadeout {
      0% {opacity:1}
      80% {opacity:1}
      100% {opacity:0}
    }
  `;
  document.head.appendChild(style);
});