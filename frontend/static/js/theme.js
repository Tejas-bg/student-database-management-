/* ==========================================================================
   GM University Management System — Theme controller
   Keeps the <html data-theme> attribute, toggle buttons, and localStorage in
   sync. Toggle buttons use [data-theme-toggle] and are announced as a switch.
   ========================================================================== */

(function () {
  "use strict";

  var STORAGE_KEY = "gmu-theme";
  var root = document.documentElement;
  var current = window.GMU_INITIAL_THEME || root.getAttribute("data-theme") || "light";

  function themeColor(theme) {
    return theme === "dark" ? "#111111" : "#f8f6f0";
  }

  function apply(theme, options) {
    var opts = options || {};
    current = theme === "dark" ? "dark" : "light";
    root.setAttribute("data-theme", current);
    root.style.colorScheme = current;

    if (!opts.skipStorage) {
      try {
        window.localStorage.setItem(STORAGE_KEY, current);
      } catch (error) {
        // Ignore storage failures; the theme still applies for this page.
      }
    }

    // Update the browser UI colour (address bar on mobile).
    var meta = document.querySelector('meta[name="theme-color"]');
    if (meta) {
      meta.setAttribute("content", themeColor(current));
    }

    // Update every toggle control on the page.
    document.querySelectorAll("[data-theme-toggle]").forEach(function (button) {
      var isDark = current === "dark";
      button.setAttribute("aria-checked", String(isDark));
      button.setAttribute("aria-label", isDark ? "Switch to light theme" : "Switch to dark theme");
      button.setAttribute("title", isDark ? "Switch to light theme" : "Switch to dark theme");

      // Optional text nodes inside the control (used on the styleguide page).
      var label = button.querySelector("[data-theme-label]");
      if (label) {
        label.textContent = isDark ? "Dark" : "Light";
      }
    });

    document.dispatchEvent(
      new CustomEvent("gmu:themechange", { detail: { theme: current } })
    );
  }

  function toggle() {
    apply(current === "dark" ? "light" : "dark");
  }

  function decorate(button) {
    button.setAttribute("role", "switch");
    button.setAttribute("aria-checked", String(current === "dark"));
  }

  // Delegated so controls injected later by app-shell.js also work.
  document.addEventListener("click", function (event) {
    var button = event.target.closest ? event.target.closest("[data-theme-toggle]") : null;
    if (button) {
      toggle();
    }
  });

  document.querySelectorAll("[data-theme-toggle]").forEach(decorate);

  // The shared shell is injected after this file runs, so sync again once the
  // document has finished parsing.
  document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll("[data-theme-toggle]").forEach(decorate);
    apply(current, { skipStorage: true });
  });

  // Follow the operating system only when the user has not saved a choice.
  var media = window.matchMedia ? window.matchMedia("(prefers-color-scheme: dark)") : null;
  if (media) {
    var onChange = function (event) {
      var hasSaved = false;
      try {
        hasSaved = Boolean(window.localStorage.getItem(STORAGE_KEY));
      } catch (error) {
        hasSaved = false;
      }
      if (!hasSaved) {
        apply(event.matches ? "dark" : "light", { skipStorage: true });
      }
    };

    if (typeof media.addEventListener === "function") {
      media.addEventListener("change", onChange);
    } else if (typeof media.addListener === "function") {
      media.addListener(onChange);
    }
  }

  apply(current, { skipStorage: true });

  // Small public API so future stages can control the theme from other files.
  window.GMU = window.GMU || {};
  window.GMU.theme = {
    get: function () {
      return current;
    },
    set: apply,
    toggle: toggle
  };
})();
