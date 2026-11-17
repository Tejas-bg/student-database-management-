/* ==========================================================================
   GM University Management System — Login page behaviour
   --------------------------------------------------------------------------
   This file only makes the DESIGN PREVIEW feel complete:

   1. Show or hide the password.
   2. Validate that both fields are filled in.
   3. Show a short loading animation when the form is submitted.
   4. Explain that authentication is not connected yet.
   5. Open and close the "forgot password" placeholder dialog.

   It deliberately does NOT:
   - send the values anywhere,
   - store the values in a browser storage API,
   - log the values to the console,
   - pretend that a user has signed in.

   Real sign-in will be handled by the Flask backend, which looks up the
   account in MySQL and decides the role on the server.
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
  var errorText = document.querySelector("#login-error-text");
  var statusBox = document.querySelector("[data-login-status]");
  var submitButton = form.querySelector("[data-login-submit]");
  var submitLabel = submitButton
    ? submitButton.querySelector(".login-submit__label")
    : null;

  var loadingTimer = null;

  /* ------------------------------------------------------------------------
     1. Helpers
     ------------------------------------------------------------------------ */

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

  function hideErrorBox() {
    if (errorBox) {
      errorBox.hidden = true;
    }
  }

  function showErrorBox(message) {
    if (errorBox && errorText) {
      errorText.textContent = message;
      errorBox.hidden = false;
    }
  }

  function setStatus(message) {
    if (statusBox) {
      statusBox.textContent = message;
    }
  }

  function setLoading(isLoading) {
    if (!submitButton) {
      return;
    }

    submitButton.disabled = isLoading;
    submitButton.setAttribute("data-loading", String(isLoading));
    submitButton.setAttribute("aria-busy", String(isLoading));

    if (submitLabel) {
      submitLabel.textContent = isLoading ? "Checking fields…" : "Sign In";
    }
  }

  /* ------------------------------------------------------------------------
     2. Show / hide password
     ------------------------------------------------------------------------ */

  document.querySelectorAll("[data-password-toggle]").forEach(function (toggle) {
    var input = document.querySelector("#" + toggle.getAttribute("data-target"));

    // If the markup ever omits data-target, fall back to the password field.
    if (!input) {
      input = password;
    }

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

      // Keep the caret at the end of the value when the type changes.
      var end = input.value.length;
      input.focus();
      try {
        input.setSelectionRange(end, end);
      } catch (error) {
        // setSelectionRange is not supported by every input type; ignore.
      }
    });
  });

  /* ------------------------------------------------------------------------
     3. Clear an error as soon as the user starts correcting it
     ------------------------------------------------------------------------ */

  [identifier, password].forEach(function (input) {
    if (!input) {
      return;
    }

    input.addEventListener("input", function () {
      setFieldError(input, false);
      hideErrorBox();
      setStatus("");
    });
  });

  /* ------------------------------------------------------------------------
     4. Validate on submit and show the honest preview state
     ------------------------------------------------------------------------ */

  function validate() {
    var missing = [];

    if (!identifier || identifier.value.trim() === "") {
      missing.push(identifier);
    }

    if (!password || password.value === "") {
      missing.push(password);
    }

    [identifier, password].forEach(function (input) {
      if (input) {
        setFieldError(input, missing.indexOf(input) !== -1);
      }
    });

    if (missing.length === 0) {
      return true;
    }

    var message =
      missing.length === 2
        ? "Enter your university login ID and password."
        : missing[0] === identifier
        ? "Enter your university login ID."
        : "Enter your password.";

    showErrorBox(message);
    missing[0].focus();
    return false;
  }

  form.addEventListener("submit", function (event) {
    // Stop the browser from trying to navigate or reload the page.
    event.preventDefault();

    setStatus("");

    if (!validate()) {
      setLoading(false);
      return;
    }

    setLoading(true);

    // The pause only demonstrates the loading state. Nothing is transmitted.
    window.clearTimeout(loadingTimer);
    loadingTimer = window.setTimeout(function () {
      setLoading(false);
      setStatus(
        "Sign-in will connect to the university account system in a later stage."
      );
    }, 900);
  });

  /* ------------------------------------------------------------------------
     5. Forgot-password placeholder dialog
     ------------------------------------------------------------------------ */

  var dialogTriggers = document.querySelectorAll("[data-dialog-open]");

  dialogTriggers.forEach(function (trigger) {
    trigger.addEventListener("click", function () {
      var selector = trigger.getAttribute("data-dialog-open");
      var dialog = document.querySelector(
        selector.charAt(0) === "#" ? selector : "#" + selector
      );

      if (!dialog) {
        return;
      }

      if (typeof dialog.showModal === "function") {
        dialog.showModal();
      } else {
        // Very old browsers without <dialog> support: keep it honest.
        setStatus(
          "Password recovery is a future feature. This preview has no account database."
        );
      }
    });
  });

  document.querySelectorAll(".login-dialog").forEach(function (dialog) {
    dialog.querySelectorAll("[data-dialog-close]").forEach(function (button) {
      button.addEventListener("click", function () {
        dialog.close();
      });
    });

    // Clicking the dimmed backdrop closes the dialog.
    dialog.addEventListener("click", function (event) {
      if (event.target === dialog) {
        dialog.close();
      }
    });

    // Return focus to the button that opened it so keyboard users do not
    // get dropped at the top of the page.
    dialog.addEventListener("close", function () {
      var opener = document.querySelector(
        '[data-dialog-open="' + dialog.id + '"], [data-dialog-open="#' + dialog.id + '"]'
      );

      if (opener) {
        opener.focus({ preventScroll: true });
      }
    });
  });
})();
