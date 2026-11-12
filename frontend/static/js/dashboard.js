/* ==========================================================================
   GM University Management System — Dashboard interaction layer (Stage 2)

   Frontend-only behaviour for the demonstration workspaces:

     - live table search and chip filters
     - client-side pagination of sample rows
     - header search that filters the current page's tables
     - demo form submissions that never send data anywhere
     - a "/" shortcut to focus search

   No fetch(), WebSocket, credential handling, or database call exists in this
   file. Every row it filters is static sample markup authored in the HTML.
   ========================================================================== */

(function () {
  "use strict";

  function ready(fn) {
    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", fn);
    } else {
      fn();
    }
  }

  function notify(title, message) {
    if (window.GMU && typeof window.GMU.toast === "function") {
      window.GMU.toast(title, message);
    }
  }

  /* ------------------------------------------------------------------------
     Tables
     ------------------------------------------------------------------------ */

  function initTables() {
    var headerSearch = document.querySelector("[data-dashboard-search] input");
    var renderers = [];

    document.querySelectorAll("[data-table-section]").forEach(function (section) {
      var table = section.querySelector("[data-demo-table]");
      if (!table || !table.tBodies.length) {
        return;
      }

      var rows = Array.prototype.slice.call(table.tBodies[0].rows);
      var pageSize = parseInt(table.getAttribute("data-page-size"), 10) || 10;
      var localSearch = section.querySelector("[data-table-search]");
      var info = section.querySelector("[data-page-info]");
      var prev = section.querySelector("[data-page-prev]");
      var next = section.querySelector("[data-page-next]");
      var chips = Array.prototype.slice.call(section.querySelectorAll("[data-filter]"));
      var state = { page: 1, filters: {} };

      function terms() {
        var list = [];
        if (localSearch && localSearch.value.trim()) {
          list.push(localSearch.value.trim().toLowerCase());
        }
        if (headerSearch && headerSearch.value.trim()) {
          list.push(headerSearch.value.trim().toLowerCase());
        }
        return list;
      }

      function matches(row) {
        var text = row.textContent.toLowerCase();
        var queries = terms();
        if (
          queries.some(function (q) {
            return text.indexOf(q) === -1;
          })
        ) {
          return false;
        }

        return Object.keys(state.filters).every(function (key) {
          var wanted = state.filters[key];
          if (!wanted) {
            return true;
          }
          var actual = (row.getAttribute("data-" + key) || "").toLowerCase();
          return actual.indexOf(wanted.toLowerCase()) !== -1;
        });
      }

      function render() {
        var visible = rows.filter(matches);
        var pages = Math.max(1, Math.ceil(visible.length / pageSize));
        if (state.page > pages) {
          state.page = pages;
        }

        var start = (state.page - 1) * pageSize;
        var end = Math.min(start + pageSize, visible.length);

        rows.forEach(function (row) {
          row.hidden = true;
        });
        visible.slice(start, end).forEach(function (row) {
          row.hidden = false;
        });

        if (info) {
          info.textContent = visible.length
            ? "Showing " + (start + 1) + "–" + end + " of " + visible.length + " sample records"
            : "No sample records match these filters";
        }
        if (prev) {
          prev.disabled = state.page <= 1;
        }
        if (next) {
          next.disabled = state.page >= pages;
        }

        var empty = section.querySelector("[data-table-empty]");
        if (empty) {
          empty.hidden = visible.length !== 0;
        }
      }

      if (localSearch) {
        localSearch.addEventListener("input", function () {
          state.page = 1;
          render();
        });
      }

      chips.forEach(function (chip) {
        chip.addEventListener("click", function () {
          var key = chip.getAttribute("data-filter");
          var value = chip.getAttribute("data-value") || "";

          chips
            .filter(function (item) {
              return item.getAttribute("data-filter") === key;
            })
            .forEach(function (item) {
              var active = item === chip;
              item.classList.toggle("is-active", active);
              item.setAttribute("aria-pressed", active ? "true" : "false");
            });

          state.filters[key] = value;
          state.page = 1;
          render();
        });
      });

      if (prev) {
        prev.addEventListener("click", function () {
          state.page = Math.max(1, state.page - 1);
          render();
        });
      }
      if (next) {
        next.addEventListener("click", function () {
          state.page += 1;
          render();
        });
      }

      render();
      renderers.push(function () {
        state.page = 1;
        render();
      });
    });

    if (headerSearch) {
      headerSearch.addEventListener("input", function () {
        renderers.forEach(function (render) {
          render();
        });
      });
    }
  }

  /* ------------------------------------------------------------------------
     Filterable lists (notifications, feedback queues)
     ------------------------------------------------------------------------ */

  function initLists() {
    document.querySelectorAll("[data-filter-list]").forEach(function (root) {
      var chips = Array.prototype.slice.call(root.querySelectorAll("[data-list-filter]"));
      var items = Array.prototype.slice.call(root.querySelectorAll("[data-list-item]"));
      var empty = root.querySelector("[data-list-empty]");

      function render() {
        var active = chips.filter(function (chip) {
          return chip.classList.contains("is-active");
        });

        var visible = items.filter(function (item) {
          return active.every(function (chip) {
            var key = chip.getAttribute("data-list-filter");
            var value = chip.getAttribute("data-value") || "";
            if (!value) {
              return true;
            }
            return (item.getAttribute("data-" + key) || "").toLowerCase() === value.toLowerCase();
          });
        });

        items.forEach(function (item) {
          item.hidden = true;
        });
        visible.forEach(function (item) {
          item.hidden = false;
        });

        if (empty) {
          empty.hidden = visible.length !== 0;
        }
      }

      chips.forEach(function (chip) {
        chip.addEventListener("click", function () {
          var key = chip.getAttribute("data-list-filter");
          chips.forEach(function (item) {
            if (item.getAttribute("data-list-filter") === key) {
              var active = item === chip;
              item.classList.toggle("is-active", active);
              item.setAttribute("aria-pressed", active ? "true" : "false");
            }
          });
          render();
        });
      });

      render();
    });
  }

  /* ------------------------------------------------------------------------
     Mark all notifications on a page as read (visual only)
     ------------------------------------------------------------------------ */

  function initMarkRead() {
    document.querySelectorAll("[data-mark-page-read]").forEach(function (button) {
      button.addEventListener("click", function () {
        document.querySelectorAll("[data-list-item]").forEach(function (item) {
          if (item.getAttribute("data-status") === "unread") {
            item.setAttribute("data-status", "read");
            var dot = item.querySelector("[data-unread-dot]");
            if (dot) {
              dot.remove();
            }
          }
        });

        document.querySelectorAll("[data-filter-list]").forEach(function (root) {
          var all = root.querySelector('[data-list-filter="status"][data-value=""]');
          if (all) {
            all.click();
          }
        });

        var summary = document.querySelector("[data-unread-summary]");
        if (summary) {
          summary.textContent = "0 unread";
        }

        notify("Notifications marked read", "This only changes the sample interface. Nothing was stored or sent.");
      });
    });
  }

  /* ------------------------------------------------------------------------
     Forms — present, keyboard accessible, and intentionally inert.
     ------------------------------------------------------------------------ */

  function initForms() {
    document.querySelectorAll("[data-demo-form]").forEach(function (form) {
      form.addEventListener("submit", function (event) {
        event.preventDefault();
        var message =
          form.getAttribute("data-demo-message") ||
          "This form is a Stage 2 interface preview. Nothing was validated, stored, or sent to a server.";
        notify("Preview only — nothing saved", message);
      });
    });
  }

  /* ------------------------------------------------------------------------
     Search shortcut
     ------------------------------------------------------------------------ */

  function initShortcut() {
    var input = document.querySelector("[data-dashboard-search] input");
    if (!input) {
      return;
    }

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

  ready(function () {
    initTables();
    initLists();
    initMarkRead();
    initForms();
    initShortcut();
  });
})();
