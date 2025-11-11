document.addEventListener('DOMContentLoaded', () => {
  const btn = document.querySelector('#hamburger');
  btn.addEventListener('click', () => btn.classList.toggle('active'));
});