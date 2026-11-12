/* ==========================================================================
   GM University Management System — Theme bootstrap
   This file is loaded as a blocking script in <head>, before the page paints.
   It applies the saved theme immediately so the page never flashes the wrong
   colours. Actual toggle logic lives in theme.js.
   ========================================================================== */

(function () {
  "use strict";

  var STORAGE_KEY = "gmu-theme";
  var root = document.documentElement;
  var saved = null;

  try {
    saved = window.localStorage.getItem(STORAGE_KEY);
  } catch (error) {
    // localStorage can be blocked (private mode / file://); fall back silently.
    saved = null;
  }

  // ?theme=light or ?theme=dark lets you preview a theme without changing the
  // saved preference. Useful for screenshots and design reviews.
  var params = new URLSearchParams(window.location.search);
  var requested = params.get("theme");
  var systemPrefersDark =
    window.matchMedia &&
    window.matchMedia("(prefers-color-scheme: dark)").matches;

  var theme;
  if (requested === "light" || requested === "dark") {
    theme = requested;
  } else if (saved === "light" || saved === "dark") {
    theme = saved;
  } else {
    theme = systemPrefersDark ? "dark" : "light";
  }

  root.setAttribute("data-theme", theme);
  root.style.colorScheme = theme;

  // Expose the initial value so theme.js does not need to re-read storage.
  window.GMU_INITIAL_THEME = theme;
})();
