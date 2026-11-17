/* ==========================================================================
   GM University Management System — live login form behaviour
   --------------------------------------------------------------------------
   Complements the server-rendered form:
   1. Show or hide the password.
   2. Validate empty fields before the browser submits.
   3. Keep the forgot-password dialog usable.

   It never blocks a valid submit and never stores credentials.
   ========================================================================== */

(function () {
  "use strict";

  var form = document.querySelector("#login-form");

  if (!form) {
    return;
  }

  var identifier = document.querySelector("#login-id");
  var password = document.querySelector("#password");
  var errorBox = document.querySelector("#login-error");
  var submitButton = form.querySelector("[data-login-submit]");
  var submitLabel = submitButton
    ? submitButton.querySelector(".login-submit__label")
    : null;

  function fieldError(input) {
    return document.querySelector("#" + input.id + "-error");
  }

  function setFieldError(input, hasError) {
    var message = fieldError(input);

    if (hasError) {
      input.setAttribute("aria-invalid", "true");
    } else {
      input.removeAttribute("aria-invalid");
    }

    if (message) {
      message.hidden = !hasError;
    }
  }

  function setStatus(message) {
    var statusBox = document.querySelector("[data-login-status]");
    if (statusBox) {
      statusBox.textContent = message;
    }
  }

  /* 1. Show / hide password */
  document.querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    var input = document.querySelector("#" + toggle.getAttribute("data-target")) || password;

    if (!input) {
      return;
    }

    toggle.addEventListener("click", function () {
      var willShow = input.type === "password";

      input.type = willShow ? "text" : "password";
      toggle.setAttribute("aria-pressed", String(willShow));
      toggle.setAttribute(
        "aria-label",
        willShow ? "Hide password" : "Show password"
      );

      var end = input.value.length;
      input.focus();
      try {
        input.setSelectionRange(end, end);
      } catch (error) {
        /* Not supported by every input type; ignore. */
      }
    });
  });

  /* 2. Clear a server error as soon as the user edits a field */
  [identifier, password].forEach(function (input) {
    if (!input) {
      return;
    }

    input.addEventListener("input", function () {
      setFieldError(input, false);
      if (errorBox) {
        errorBox.hidden = true;
      }
      setStatus("");
    });
  });

  /* 3. Validate empty fields, then let the form post normally */
  form.addEventListener("submit", function (event) {
    var missing = [];

    if (!identifier || identifier.value.trim() === "") {
      missing.push(identifier);
    }

    if (!password || password.value === "") {
      missing.push(password);
    }

    if (missing.length === 0) {
      if (submitButton) {
        submitButton.disabled = true;
        submitButton.setAttribute("aria-busy", "true");
        if (submitLabel) {
          submitLabel.textContent = "Signing in…";
        }
      }
      return;
    }

    event.preventDefault();

    [identifier, password].forEach(function (input) {
      if (input) {
        setFieldError(input, missing.indexOf(input) !== -1);
      }
    });

    var message =
      missing.length === 2
        ? "Enter your university login ID and password."
        : missing[0] === identifier
        ? "Enter your university login ID."
        : "Enter your password.";

    setStatus(message);
    missing[0].focus();
  });

  /* 4. Forgot-password link - now navigates to a dedicated page */
  // The "Forgot password?" link is a standard anchor that navigates to
  // /forgot-password. No dialog handling needed here.
})();
