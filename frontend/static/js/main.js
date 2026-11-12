/* ==========================================================================
   GM University Management System — Interaction layer (Stage 1)
   Stage 1 is a visual preview. Everything here is interface behaviour only:
   navigation drawer, dropdown menus, tabs, dialogs, and toasts. There is no
   backend, no authentication, and no database connection.
   ========================================================================== */

(function () {
  "use strict";

  var reduceMotion = window.matchMedia
    ? window.matchMedia("(prefers-reduced-motion: reduce)")
    : { matches: false };

  /* ------------------------------------------------------------------------
     Mobile navigation drawer
     ------------------------------------------------------------------------ */

  function initNavigation() {
    var sidebar = document.querySelector("[data-sidebar]");
    var toggle = document.querySelector("[data-nav-toggle]");
    var overlay = document.querySelector("[data-nav-overlay]");
    var shell = document.querySelector(".nx-shell");

    if (!sidebar || !toggle) {
      return;
    }

    var lastFocused = null;

    function focusableItems() {
      return Array.prototype.slice
        .call(sidebar.querySelectorAll("a[href], button:not([disabled]), input, select, textarea"))
        .filter(function (el) {
          return el.offsetParent !== null;
        });
    }

    function setOpen(open) {
      sidebar.classList.toggle("is-open", open);
      document.body.classList.toggle("nx-nav-open", open);
      toggle.setAttribute("aria-expanded", String(open));
      toggle.setAttribute("aria-label", open ? "Close navigation" : "Open navigation");

      if (overlay) {
        overlay.classList.toggle("is-visible", open);
        overlay.hidden = false;
      }

      // The drawer behaves like a modal panel on small screens: everything
      // outside it becomes inert while it is open.
      if (shell) {
        shell.inert = open;
      }

      if (open) {
        var active = document.activeElement;
        lastFocused = active && active !== document.body ? active : toggle;
        var firstLink = focusableItems()[0] || sidebar.querySelector("a, button");
        if (firstLink) {
          firstLink.focus({ preventScroll: true });
        }
      } else {
        if (shell) {
          shell.inert = false;
        }
        if (lastFocused && lastFocused.isConnected && typeof lastFocused.focus === "function") {
          lastFocused.focus({ preventScroll: true });
        } else {
          toggle.focus({ preventScroll: true });
        }
      }
    }

    toggle.addEventListener("click", function () {
      setOpen(toggle.getAttribute("aria-expanded") !== "true");
    });

    if (overlay) {
      overlay.addEventListener("click", function () {
        setOpen(false);
      });
    }

    sidebar.addEventListener("click", function (event) {
      var link = event.target.closest("a");
      if (link && window.innerWidth <= 1024) {
        setOpen(false);
      }
    });

    document.addEventListener("keydown", function (event) {
      if (!sidebar.classList.contains("is-open")) {
        return;
      }

      if (event.key === "Escape") {
        setOpen(false);
        return;
      }

      // Keep Tab inside the open drawer.
      if (event.key === "Tab") {
        var items = focusableItems();
        if (!items.length) {
          return;
        }
        var first = items[0];
        var last = items[items.length - 1];

        if (event.shiftKey && document.activeElement === first) {
          event.preventDefault();
          last.focus();
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault();
          first.focus();
        }
      }
    });

    window.addEventListener("resize", function () {
      if (window.innerWidth > 1024 && sidebar.classList.contains("is-open")) {
        setOpen(false);
      }
    });
  }

  /* ------------------------------------------------------------------------
     Dropdown menus
     ------------------------------------------------------------------------ */

  function initMenus() {
    var toggles = Array.prototype.slice.call(document.querySelectorAll("[data-menu-toggle]"));

    function closeMenu(toggle, returnFocus) {
      var menu = document.getElementById(toggle.getAttribute("aria-controls"));
      if (!menu) {
        return;
      }
      var wasOpen = menu.classList.contains("is-open");
      menu.classList.remove("is-open");
      toggle.setAttribute("aria-expanded", "false");
      if (returnFocus && wasOpen) {
        toggle.focus({ preventScroll: true });
      }
    }

    function closeAll(except, returnFocus) {
      toggles.forEach(function (toggle) {
        if (toggle !== except) {
          closeMenu(toggle, returnFocus);
        }
      });
    }

    toggles.forEach(function (toggle) {
      var menu = document.getElementById(toggle.getAttribute("aria-controls"));
      if (!menu) {
        return;
      }

      toggle.setAttribute("aria-expanded", "false");
      toggle.setAttribute("aria-haspopup", "true");

      toggle.addEventListener("click", function (event) {
        event.stopPropagation();
        var isOpen = menu.classList.contains("is-open");
        closeAll(toggle);
        menu.classList.toggle("is-open", !isOpen);
        toggle.setAttribute("aria-expanded", String(!isOpen));

        if (!isOpen) {
          var firstItem = menu.querySelector("a, button");
          if (firstItem) {
            // Wait one frame so the menu's visibility transition has started;
            // a visibility:hidden element cannot receive focus.
            window.setTimeout(function () {
              if (menu.classList.contains("is-open")) {
                firstItem.focus({ preventScroll: true });
              }
            }, 20);
          }
        }
      });

      // Tabbing out of the menu closes it.
      menu.addEventListener("keydown", function (event) {
        if (event.key === "Escape") {
          closeMenu(toggle, true);
        }
      });

      menu.addEventListener("focusout", function (event) {
        if (!menu.contains(event.relatedTarget) && event.relatedTarget !== toggle) {
          closeMenu(toggle);
        }
      });
    });

    document.addEventListener("click", function (event) {
      if (!event.target.closest("[data-menu-toggle]") && !event.target.closest(".nx-menu")) {
        closeAll();
      }
    });

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        closeAll(null, true);
      }
    });
  }

  /* ------------------------------------------------------------------------
     Tabs
     ------------------------------------------------------------------------ */

  function initTabs() {
    document.querySelectorAll("[data-tabs]").forEach(function (tablist) {
      var tabs = Array.prototype.slice.call(tablist.querySelectorAll("[data-tab]"));
      var panelRoot = document.getElementById(tablist.getAttribute("data-tabs"));
      if (!tabs.length || !panelRoot) {
        return;
      }

      var panels = Array.prototype.slice.call(panelRoot.querySelectorAll("[data-tab-panel]"));

      function activate(tab) {
        var target = tab.getAttribute("data-tab");

        tabs.forEach(function (item) {
          var selected = item === tab;
          item.setAttribute("aria-selected", String(selected));
          item.setAttribute("tabindex", selected ? "0" : "-1");
        });

        panels.forEach(function (panel) {
          panel.hidden = panel.getAttribute("data-tab-panel") !== target;
        });
      }

      tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
          activate(tab);
        });

        tab.addEventListener("keydown", function (event) {
          var index = tabs.indexOf(tab);
          var next = null;

          if (event.key === "ArrowRight") {
            next = tabs[(index + 1) % tabs.length];
          } else if (event.key === "ArrowLeft") {
            next = tabs[(index - 1 + tabs.length) % tabs.length];
          } else if (event.key === "Home") {
            next = tabs[0];
          } else if (event.key === "End") {
            next = tabs[tabs.length - 1];
          }

          if (next) {
            event.preventDefault();
            next.focus();
            activate(next);
          }
        });
      });
    });
  }

  /* ------------------------------------------------------------------------
     Dialogs
     ------------------------------------------------------------------------ */

  function initDialogs() {
    document.querySelectorAll("[data-dialog-open]").forEach(function (trigger) {
      trigger.addEventListener("click", function () {
        var dialog = document.querySelector(trigger.getAttribute("data-dialog-open"));
        if (dialog && typeof dialog.showModal === "function") {
          dialog.showModal();
        }
      });
    });

    document.querySelectorAll(".nx-dialog").forEach(function (dialog) {
      dialog.querySelectorAll("[data-dialog-close]").forEach(function (button) {
        button.addEventListener("click", function () {
          dialog.close();
        });
      });

      // Clicking the dimmed area outside the dialog closes it.
      dialog.addEventListener("click", function (event) {
        if (event.target === dialog) {
          dialog.close();
        }
      });

      dialog.addEventListener("close", function () {
        var opener = document.querySelector('[data-dialog-open="#' + dialog.id + '"]');
        if (opener) {
          opener.focus({ preventScroll: true });
        }
      });
    });
  }

  /* ------------------------------------------------------------------------
     Toasts
     ------------------------------------------------------------------------ */

  function toast(title, message, options) {
    var opts = options || {};
    var region = document.querySelector("[data-toast-region]");
    if (!region) {
      return;
    }

    var el = document.createElement("div");
    el.className = "nx-toast";
    el.setAttribute("role", "status");

    var icon = document.createElement("span");
    icon.className = "nx-toast__icon";
    icon.setAttribute("aria-hidden", "true");
    icon.innerHTML =
      '<svg class="nx-icon nx-icon--sm" viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></svg>';

    var body = document.createElement("div");
    body.className = "nx-toast__body";

    var strong = document.createElement("strong");
    strong.textContent = title;

    var p = document.createElement("p");
    p.textContent = message;

    body.appendChild(strong);
    body.appendChild(p);

    var close = document.createElement("button");
    close.type = "button";
    close.className = "nx-toast__close";
    close.setAttribute("aria-label", "Dismiss notification");
    close.innerHTML =
      '<svg class="nx-icon nx-icon--sm" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></svg>';

    el.appendChild(icon);
    el.appendChild(body);
    el.appendChild(close);
    region.appendChild(el);

    var timer = window.setTimeout(remove, opts.duration || 4200);

    function remove() {
      window.clearTimeout(timer);
      el.classList.add("nx-toast--leaving");
      var delay = reduceMotion.matches ? 0 : 180;
      window.setTimeout(function () {
        el.remove();
      }, delay);
    }

    close.addEventListener("click", remove);

    return el;
  }

  function initToasts() {
    // Buttons can show a demo toast without writing any JavaScript:
    //   <button data-toast="Title|Message">…</button>
    document.querySelectorAll("[data-toast]").forEach(function (trigger) {
      trigger.addEventListener("click", function (event) {
        var parts = trigger.getAttribute("data-toast").split("|");
        toast(parts[0] || "Preview", parts[1] || "This action is not wired up in Stage 1.");
        if (trigger.tagName === "A" && (trigger.getAttribute("href") || "#") === "#") {
          event.preventDefault();
        }
      });
    });

    var searchForms = document.querySelectorAll("[data-demo-search]");
    searchForms.forEach(function (form) {
      form.addEventListener("submit", function (event) {
        event.preventDefault();
        toast(
          "Search is a visual demo",
          "Search will query real records in a later stage. No data was changed."
        );
      });
    });

    var markAll = document.querySelector("[data-mark-all-read]");
    if (markAll) {
      markAll.addEventListener("click", function () {
        document.querySelectorAll("[data-unread-dot]").forEach(function (dot) {
          dot.remove();
        });
        var count = document.querySelector("[data-unread-count]");
        if (count) {
          count.remove();
        }
        toast("Notifications cleared", "All demo notifications are marked as read.");
      });
    }
  }

  /* ------------------------------------------------------------------------
     Demo-only guards
     Placeholder links should never navigate away and break the preview.
     ------------------------------------------------------------------------ */

  function initPlaceholderLinks() {
    document.querySelectorAll('a[href="#"]').forEach(function (link) {
      if (link.hasAttribute("data-toast") || link.hasAttribute("data-dialog-open")) {
        return;
      }
      link.addEventListener("click", function (event) {
        event.preventDefault();
      });
    });
  }

  /* ------------------------------------------------------------------------
     Styleguide filter
     A small convenience on styleguide.html: filters documentation blocks by
     their visible text. It is not part of the product UI.
     ------------------------------------------------------------------------ */

  function initDocFilter() {
    var input = document.querySelector("[data-doc-filter]");
    if (!input) {
      return;
    }

    var blocks = Array.prototype.slice.call(document.querySelectorAll(".nx-doc-block"));

    function filter() {
      var query = input.value.trim().toLowerCase();

      blocks.forEach(function (block) {
        block.hidden = Boolean(query) && block.textContent.toLowerCase().indexOf(query) === -1;
      });
    }

    input.addEventListener("input", filter);

    // Pressing "/" focuses the filter when the user is not already typing.
    document.addEventListener("keydown", function (event) {
      var tag = (document.activeElement && document.activeElement.tagName) || "";
      var typing = tag === "INPUT" || tag === "TEXTAREA" || tag === "SELECT";
      if (event.key === "/" && !typing) {
        event.preventDefault();
        input.focus();
      }
    });
  }

  /* ------------------------------------------------------------------------
     Boot
     ------------------------------------------------------------------------ */

  function boot() {
    initNavigation();
    initMenus();
    initTabs();
    initDialogs();
    initToasts();
    initPlaceholderLinks();
    initDocFilter();

    window.GMU = window.GMU || {};
    window.GMU.toast = toast;
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", boot);
  } else {
    boot();
  }
})();
