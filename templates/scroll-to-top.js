const btn = document.getElementById("scrollToTopBtn");

window.onscroll = function () {
  if (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300) {
    btn.style.display = "flex";
  } else {
    btn.style.display = "none";
  }
};

btn.addEventListener("click", function () {
  window.scrollTo({ top: 0, behavior: "smooth" });
});
