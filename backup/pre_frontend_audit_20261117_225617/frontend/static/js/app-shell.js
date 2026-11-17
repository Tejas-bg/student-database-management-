/* ==========================================================================
   GM University Management System — Shared application shell (interface)

   Every role page declares its identity on <body> and this module renders the
   common sidebar, header, breadcrumb, demo notice, and footer around the page's
   own <main> content:

     <body data-role="student" data-page="courses"
           data-title="My Courses" data-subtitle="Enrolled subjects"
           data-breadcrumb="My Courses" data-search="Search courses…">

   This is presentation-only wiring. No authentication, session, or database
   call happens here. Links between pages are ordinary static HTML files.
   ========================================================================== */

(function () {
  "use strict";

  var body = document.body;
  var role = body.getAttribute("data-role") || "student";
  var page = body.getAttribute("data-page") || "index";
  var pageTitle = body.getAttribute("data-title") || "Dashboard";
  var pageSubtitle = body.getAttribute("data-subtitle") || "Workspace";
  var breadcrumb = body.getAttribute("data-breadcrumb") || pageTitle;
  var searchPlaceholder = body.getAttribute("data-search") || "Search records…";

  var LOGIN_HREF = "../../login.html";
  var LOGO_SRC = "../../static/img/branding/gmu-official-logo.jpg";

  /* ------------------------------------------------------------------------
     Icon sprite — shared by every page so individual files stay small.
     ------------------------------------------------------------------------ */

  var SPRITE =
    '<svg class="nx-svg-sprite" aria-hidden="true" focusable="false" xmlns="http://www.w3.org/2000/svg">' +
    '<symbol id="i-grid" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7" rx="1.5"/><rect x="14" y="3" width="7" height="7" rx="1.5"/><rect x="3" y="14" width="7" height="7" rx="1.5"/><rect x="14" y="14" width="7" height="7" rx="1.5"/></symbol>' +
    '<symbol id="i-users" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87M16 3.13a4 4 0 0 1 0 7.75"/></symbol>' +
    '<symbol id="i-faculty" viewBox="0 0 24 24"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="m16 11 2 2 4-4"/></symbol>' +
    '<symbol id="i-building" viewBox="0 0 24 24"><path d="M3 21h18M5 21V5a2 2 0 0 1 2-2h6a2 2 0 0 1 2 2v16M15 9h2a2 2 0 0 1 2 2v10"/><path d="M9 7h2M9 11h2M9 15h2"/></symbol>' +
    '<symbol id="i-book" viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2Z"/></symbol>' +
    '<symbol id="i-layers" viewBox="0 0 24 24"><path d="m12 2 9 5-9 5-9-5 9-5Z"/><path d="m3 12 9 5 9-5"/><path d="m3 17 9 5 9-5"/></symbol>' +
    '<symbol id="i-clipboard" viewBox="0 0 24 24"><rect x="8" y="2" width="8" height="4" rx="1"/><path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2"/><path d="M9 12h6M9 16h6"/></symbol>' +
    '<symbol id="i-calendar-check" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/><path d="m9 16 2 2 4-4"/></symbol>' +
    '<symbol id="i-file-text" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8Z"/><path d="M14 2v6h6M16 13H8M16 17H8M10 9H8"/></symbol>' +
    '<symbol id="i-award" viewBox="0 0 24 24"><circle cx="12" cy="8" r="6"/><path d="m8.5 13.5-1.5 8 5-3 5 3-1.5-8"/></symbol>' +
    '<symbol id="i-credit-card" viewBox="0 0 24 24"><rect x="2" y="5" width="20" height="14" rx="2"/><path d="M2 10h20M6 15h2"/></symbol>' +
    '<symbol id="i-message" viewBox="0 0 24 24"><path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2Z"/><path d="M8 9h8M8 13h5"/></symbol>' +
    '<symbol id="i-chart" viewBox="0 0 24 24"><path d="M3 3v18h18"/><path d="M7 16v-5M12 16V7M17 16v-8"/></symbol>' +
    '<symbol id="i-database" viewBox="0 0 24 24"><ellipse cx="12" cy="5" rx="8" ry="3"/><path d="M4 5v6c0 1.66 3.58 3 8 3s8-1.34 8-3V5"/><path d="M4 11v6c0 1.66 3.58 3 8 3s8-1.34 8-3v-6"/></symbol>' +
    '<symbol id="i-sliders" viewBox="0 0 24 24"><path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="18" cy="18" r="2"/></symbol>' +
    '<symbol id="i-lock" viewBox="0 0 24 24"><rect x="4" y="10" width="16" height="11" rx="2"/><path d="M8 10V7a4 4 0 0 1 8 0v3"/></symbol>' +
    '<symbol id="i-search" viewBox="0 0 24 24"><circle cx="11" cy="11" r="7"/><path d="m20 20-3.5-3.5"/></symbol>' +
    '<symbol id="i-bell" viewBox="0 0 24 24"><path d="M18 8a6 6 0 0 0-12 0c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.7 21a2 2 0 0 1-3.4 0"/></symbol>' +
    '<symbol id="i-sun" viewBox="0 0 24 24"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.42 1.42M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.42-1.42M17.66 6.34l1.41-1.41"/></symbol>' +
    '<symbol id="i-moon" viewBox="0 0 24 24"><path d="M21 12.8A9 9 0 1 1 11.2 3a7 7 0 0 0 9.8 9.8Z"/></symbol>' +
    '<symbol id="i-menu" viewBox="0 0 24 24"><path d="M3 6h18M3 12h18M3 18h18"/></symbol>' +
    '<symbol id="i-panel-left" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="16" rx="2"/><path d="M9 4v16"/></symbol>' +
    '<symbol id="i-chevron-down" viewBox="0 0 24 24"><path d="m6 9 6 6 6-6"/></symbol>' +
    '<symbol id="i-arrow-up-right" viewBox="0 0 24 24"><path d="M7 17 17 7M8 7h9v9"/></symbol>' +
    '<symbol id="i-arrow-right" viewBox="0 0 24 24"><path d="M4 12h16M14 6l6 6-6 6"/></symbol>' +
    '<symbol id="i-plus" viewBox="0 0 24 24"><path d="M12 5v14M5 12h14"/></symbol>' +
    '<symbol id="i-check" viewBox="0 0 24 24"><path d="M20 6 9 17l-5-5"/></symbol>' +
    '<symbol id="i-x" viewBox="0 0 24 24"><path d="M18 6 6 18M6 6l12 12"/></symbol>' +
    '<symbol id="i-info" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 11v5M12 8h.01"/></symbol>' +
    '<symbol id="i-clock" viewBox="0 0 24 24"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></symbol>' +
    '<symbol id="i-user" viewBox="0 0 24 24"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/></symbol>' +
    '<symbol id="i-user-plus" viewBox="0 0 24 24"><path d="M15 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="8.5" cy="7" r="4"/><path d="M19 8v6M22 11h-6"/></symbol>' +
    '<symbol id="i-calendar" viewBox="0 0 24 24"><rect x="3" y="4" width="18" height="18" rx="2"/><path d="M16 2v4M8 2v4M3 10h18"/></symbol>' +
    '<symbol id="i-download" viewBox="0 0 24 24"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><path d="m7 10 5 5 5-5M12 15V3"/></symbol>' +
    '<symbol id="i-alert" viewBox="0 0 24 24"><path d="M10.3 3.9 1.8 18a2 2 0 0 0 1.7 3h17a2 2 0 0 0 1.7-3L13.7 3.9a2 2 0 0 0-3.4 0Z"/><path d="M12 9v4M12 17h.01"/></symbol>' +
    '<symbol id="i-refresh" viewBox="0 0 24 24"><path d="M21 12a9 9 0 0 1-15.5 6.2L3 16"/><path d="M3 21v-5h5"/><path d="M3 12a9 9 0 0 1 15.5-6.2L21 8"/><path d="M21 3v5h-5"/></symbol>' +
    '<symbol id="i-filter" viewBox="0 0 24 24"><path d="M22 3H2l8 9.5V19l4 2v-8.5Z"/></symbol>' +
    '<symbol id="i-more" viewBox="0 0 24 24"><circle cx="5" cy="12" r="1"/><circle cx="12" cy="12" r="1"/><circle cx="19" cy="12" r="1"/></symbol>' +
    '<symbol id="i-trend" viewBox="0 0 24 24"><path d="m3 17 6-6 4 4 8-8"/><path d="M15 7h6v6"/></symbol>' +
    "</svg>";

  /* ------------------------------------------------------------------------
     Role configuration
     ------------------------------------------------------------------------ */

  var ROLES = {
    student: {
      label: "Student workspace",
      name: "Student record",
      meta: "Computer Science · Semester 5",
      initials: "SA",
      profile: "profile.html",
      dashboard: "index.html",
      nav: [
        {
          label: "Overview",
          items: [{ page: "index", href: "index.html", text: "Dashboard", icon: "i-grid" }]
        },
        {
          label: "Academic",
          items: [
            { page: "courses", href: "courses.html", text: "My Courses", icon: "i-book" },
            { page: "attendance", href: "attendance.html", text: "Attendance", icon: "i-calendar-check" },
            { page: "assessments", href: "assessments.html", text: "Internal Assessment Marks", icon: "i-file-text" },
            { page: "results", href: "results.html", text: "Semester Results", icon: "i-award" },
            { page: "fees", href: "fees.html", text: "Fee Details", icon: "i-credit-card" },
            { page: "timetable", href: "timetable.html", text: "Timetable", icon: "i-clock" }
          ]
        },
        {
          label: "Engagement",
          items: [
            { page: "notifications", href: "notifications.html", text: "Notifications", icon: "i-bell" },
            { page: "feedback", href: "feedback.html", text: "Feedback", icon: "i-message" }
          ]
        },
        {
          label: "Account",
          items: [{ page: "profile", href: "profile.html", text: "My Profile", icon: "i-user" }]
        }
      ],
      notifications: [
        ["i-user-plus", "Update: enrolment confirmation", "Semester 5 enrolment is confirmed.", "10 min"],
        ["i-file-text", "Update: IA-2 marks published", "Internal assessment marks are ready to review.", "2 hr"],
        ["i-credit-card", "Update: fee reminder", "A tuition instalment is due next week.", "1 day"]
      ]
    },

    faculty: {
      label: "Faculty workspace",
      name: "Dr. Anita Rao",
      meta: "Computer Science · Faculty",
      initials: "AR",
      profile: "profile.html",
      dashboard: "index.html",
      nav: [
        {
          label: "Overview",
          items: [{ page: "index", href: "index.html", text: "Dashboard", icon: "i-grid" }]
        },
        {
          label: "Teaching",
          items: [
            { page: "subjects", href: "subjects.html", text: "Assigned Subjects", icon: "i-book" },
            { page: "students", href: "students.html", text: "Student Management", icon: "i-users" },
            { page: "attendance", href: "attendance.html", text: "Attendance Management", icon: "i-calendar-check" },
            { page: "marks-entry", href: "marks-entry.html", text: "Internal Marks Entry", icon: "i-file-text" },
            { page: "semester-marks", href: "semester-marks.html", text: "Semester Marks", icon: "i-award" },
            { page: "performance", href: "performance.html", text: "Class Performance", icon: "i-chart" }
          ]
        },
        {
          label: "Insights",
          items: [
            { page: "reports", href: "reports.html", text: "Reports", icon: "i-clipboard" },
            { page: "notifications", href: "notifications.html", text: "Notifications", icon: "i-bell" }
          ]
        },
        {
          label: "Account",
          items: [{ page: "profile", href: "profile.html", text: "Faculty Profile", icon: "i-user" }]
        }
      ],
      notifications: [
        ["i-file-text", "Update: marks entry window", "The IA-2 entry closes this Friday.", "20 min"],
        ["i-users", "Update: attendance shortfall", "Three students in the roster are below 75%.", "3 hr"],
        ["i-message", "Update: student query", "A doubt is waiting in the feedback list.", "1 day"]
      ]
    },

    admin: {
      label: "Administration workspace",
      name: "Administrator record",
      meta: "Registrar office · Administration",
      initials: "AD",
      profile: "users.html",
      dashboard: "index.html",
      nav: [
        {
          label: "Overview",
          items: [{ page: "index", href: "index.html", text: "Dashboard", icon: "i-grid" }]
        },
        {
          label: "People",
          items: [
            { page: "students", href: "students.html", text: "Student Management", icon: "i-users" },
            { page: "faculty", href: "faculty.html", text: "Faculty Management", icon: "i-faculty" },
            { page: "users", href: "users.html", text: "User and Role Management", icon: "i-lock" }
          ]
        },
        {
          label: "Academics",
          items: [
            { page: "departments", href: "departments.html", text: "Department Management", icon: "i-building" },
            { page: "courses", href: "courses.html", text: "Course Management", icon: "i-book" },
            { page: "subjects", href: "subjects.html", text: "Subject Management", icon: "i-layers" },
            { page: "semesters", href: "semesters.html", text: "Semester Management", icon: "i-calendar" },
            { page: "enrolments", href: "enrolments.html", text: "Enrolment Management", icon: "i-user-plus" }
          ]
        },
        {
          label: "Operations",
          items: [
            { page: "attendance", href: "attendance.html", text: "Attendance Management", icon: "i-calendar-check" },
            { page: "marks", href: "marks.html", text: "Marks Management", icon: "i-file-text" },
            { page: "fees", href: "fees.html", text: "Fee Management", icon: "i-credit-card" },
            { page: "feedback", href: "feedback.html", text: "Feedback Management", icon: "i-message" }
          ]
        },
        {
          label: "Insights",
          items: [{ page: "reports", href: "reports.html", text: "Reports and Analytics", icon: "i-chart" }]
        }
      ],
      notifications: [
        ["i-user-plus", "Update: admission queue", "Twelve applications are marked pending review.", "5 min"],
        ["i-credit-card", "Update: fee reconciliation", "A batch of 24 receipts is ready to reconcile.", "2 hr"],
        ["i-clipboard", "Update: monthly report", "The attendance report is ready.", "1 day"]
      ]
    }
  };

  var config = ROLES[role] || ROLES.student;
  var roleTitle = role.charAt(0).toUpperCase() + role.slice(1);

  var DEFAULT_SEARCH_TYPE_BY_PAGE = {
    index: "students",
    students: "students",
    faculty: "faculty",
    courses: "courses",
    departments: "departments",
  };
  var SEARCH_TYPES = {
    students: "students",
    faculty: "faculty",
    courses: "courses",
    departments: "departments",
  };
  var GREETING_SELECTORS = [
    "#page-title",
    "#welcome-title",
    "#student-welcome-title",
    "#faculty-welcome-title",
    "#admin-welcome-title",
  ];


  /* ------------------------------------------------------------------------
     Small helpers
     ------------------------------------------------------------------------ */

  function esc(value) {
    return String(value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;");
  }

  function icon(id, extraClass) {
    return (
      '<svg class="nx-icon ' + (extraClass || "") + '" aria-hidden="true"><use href="#' + id + '"/></svg>'
    );
  }

  /* ------------------------------------------------------------------------
     Sidebar
     ------------------------------------------------------------------------ */

  function buildSidebar() {
    var sections = config.nav
      .map(function (section) {
        var items = section.items
          .map(function (item) {
            var current = item.page === page;
            return (
              '<a class="nx-nav-item" href="' + item.href + '"' +
              (current ? ' aria-current="page"' : "") +
              ' title="' + esc(item.text) + '">' +
              icon(item.icon) +
              '<span class="nx-nav-item__text">' + esc(item.text) + "</span>" +
              "</a>"
            );
          })
          .join("");

        return (
          '<div class="nx-sidebar__section">' +
          '<p class="nx-sidebar__label">' + esc(section.label) + "</p>" +
          '<nav class="nx-sidebar__nav" aria-label="' + esc(section.label) + '">' +
          items +
          "</nav></div>"
        );
      })
      .join("");

    return (
      '<aside class="nx-sidebar" id="sidebar" data-sidebar aria-label="Main navigation">' +
      '<div class="nx-sidebar__brand">' +
      '<a class="nx-brand" href="' + config.dashboard + '" aria-label="GM University Management System home">' +
      '<span class="nx-brand__mark" aria-hidden="true">' +
      '<img src="' + LOGO_SRC + '" alt="" width="40" height="40">' +
      "</span>" +
      '<span class="nx-brand__text">' +
      '<span class="nx-brand__name">GM UNIVERSITY</span>' +
      '<span class="nx-brand__tagline">Management System</span>' +
      "</span></a></div>" +
      sections +
      '<div class="nx-sidebar__footer">' +
      '<div class="nx-sidebar__meta">' +
      '<span class="nx-status nx-status--pending">' +
      '<span class="nx-status__dot" aria-hidden="true"></span>' +
      "University records" +
      "</span>" +
      '<span class="nx-mono">GMU · MANAGEMENT SYSTEM</span>' +
      "</div></div>" +
      "</aside>"
    );
  }

  /* ------------------------------------------------------------------------
     Header
     ------------------------------------------------------------------------ */

  function buildNotifications() {
    return config.notifications
      .map(function (item) {
        return (
          '<div class="nx-notification">' +
          '<span class="nx-notification__icon" aria-hidden="true">' +
          icon(item[0], "nx-icon--sm") +
          "</span>" +
          '<div class="nx-notification__body">' +
          "<strong>" + esc(item[1]) + "</strong>" +
          "<p>" + esc(item[2]) + "</p>" +
          '<span class="nx-notification__time">' + esc(item[3]) + "</span>" +
          "</div>" +
          '<span class="nx-notification__unread" data-unread-dot aria-label="Unread"></span>' +
          "</div>"
        );
      })
      .join("");
  }

  function buildHeader() {
    return (
      '<header class="nx-header">' +
      '<div class="nx-header__leading">' +
      '<button class="nx-btn nx-btn--ghost nx-btn--icon nx-sidebar-collapse" type="button" ' +
      'data-sidebar-collapse aria-controls="sidebar" aria-expanded="true" aria-label="Collapse sidebar">' +
      icon("i-panel-left") +
      "</button>" +
      '<div class="nx-header__title">' +
      "<strong>" + esc(pageTitle) + "</strong>" +
      "<span>" + esc(pageSubtitle) + "</span>" +
      "</div></div>" +

      '<form class="nx-header__search" role="search" aria-label="Search this page" data-dashboard-search>' +
      '<label class="nx-search">' +
      '<span class="nx-sr-only">Search this page</span>' +
      icon("i-search") +
      '<input type="search" name="q" placeholder="' + esc(searchPlaceholder) + '" autocomplete="off">' +
      '<kbd aria-hidden="true">/</kbd>' +
      "</label></form>" +

      '<div class="nx-header__actions">' +
      '<div class="nx-dropdown">' +
      '<button class="nx-btn nx-btn--ghost nx-btn--icon" type="button" data-menu-toggle ' +
      'aria-controls="notifications-menu" aria-label="Notifications, 3 unread">' +
      icon("i-bell") +
      '<span class="nx-dot-count" data-unread-count aria-hidden="true">3</span>' +
      "</button>" +
      '<div class="nx-menu nx-notifications" id="notifications-menu">' +
      '<div class="nx-cluster" style="justify-content: space-between; padding: 4px 10px 8px;">' +
      '<p class="nx-menu__label" style="padding: 0;">Notifications</p>' +
      '<button class="nx-btn nx-btn--ghost nx-btn--sm" type="button" data-mark-all-read>Mark all read</button>' +
      "</div>" +
      buildNotifications() +
      '<hr class="nx-menu__sep">' +
      '<a class="nx-menu__item" href="notifications.html" style="display:none">Notifications</a>' +
      '<span class="nx-menu__item" style="cursor: default; color: var(--nx-text-subtle); font-size: var(--nx-text-xs);">' +
      icon("i-info", "nx-icon--sm") +
      " Notifications preview" +
      "</span>" +
      "</div></div>" +

      '<button class="nx-btn nx-btn--ghost nx-btn--icon" type="button" data-theme-toggle ' +
      'aria-label="Switch to dark theme" title="Switch to dark theme">' +
      icon("i-moon", "nx-theme-icon nx-theme-icon--moon") +
      icon("i-sun", "nx-theme-icon nx-theme-icon--sun") +
      "</button>" +

      '<div class="nx-dropdown">' +
      '<button class="nx-profile-btn" type="button" data-menu-toggle aria-controls="profile-menu" ' +
      'aria-label="Account menu">' +
      '<span class="nx-avatar nx-avatar--accent" aria-hidden="true">' + config.initials + "</span>" +
      '<span class="nx-profile-btn__meta">' +
      "<strong>" + esc(config.name) + "</strong>" +
      "<span>" + esc(config.meta) + "</span>" +
      "</span>" +
      icon("i-chevron-down", "nx-icon--sm nx-text-muted") +
      "</button>" +
      '<div class="nx-menu" id="profile-menu">' +
      '<p class="nx-menu__label">Account</p>' +
      '<a class="nx-menu__item" href="' + config.profile + '">' +
      icon("i-user", "nx-icon--sm") + "Profile and preferences</a>" +
      '<a class="nx-menu__item" href="#" data-toast="Preferences|Theme, notification, and language settings arrive in a later stage.">' +
      icon("i-sliders", "nx-icon--sm") + "Preferences</a>" +
      '<hr class="nx-menu__sep">' +
      '<a class="nx-menu__item nx-menu__item--danger" href="' + LOGIN_HREF + '">' +
      icon("i-x", "nx-icon--sm") + "Sign out</a>" +
      "</div></div></div></header>"
    );
  }

  /* ------------------------------------------------------------------------
     Footer, breadcrumb, demo notice
     ------------------------------------------------------------------------ */

  function buildFooter() {
    return (
      '<footer class="nx-footer">' +
      "<span>GM University Management System</span>" +
      "<span>Academic management workspace.</span>" +
      "</footer>"
    );
  }

  function buildBreadcrumb() {
    if (page === "index") {
      return (
        '<nav class="nx-breadcrumb" aria-label="Breadcrumb">' +
        '<a href="index.html">GMU Management System</a>' +
        '<span class="nx-breadcrumb__sep" aria-hidden="true">/</span>' +
        '<span aria-current="page">' + roleTitle + " dashboard</span>" +
        "</nav>"
      );
    }

    return (
      '<nav class="nx-breadcrumb" aria-label="Breadcrumb">' +
      '<a href="index.html">' + roleTitle + " dashboard</a>" +
      '<span class="nx-breadcrumb__sep" aria-hidden="true">/</span>' +
      '<span aria-current="page">' + esc(breadcrumb) + "</span>" +
      "</nav>"
    );
  }

  /* ------------------------------------------------------------------------
     Personalized greeting + server-backed search
     ------------------------------------------------------------------------ */

  function updateGreetings(name) {
    var label = name && String(name).trim() ? String(name).trim() : "there";
    var hour = new Date().getHours();
    var period = hour < 12 ? "morning" : hour < 17 ? "afternoon" : "evening";
    var text = "Good " + period + ", " + label + ".";
    GREETING_SELECTORS.forEach(function (selector) {
      var heading = document.querySelector(selector);
      if (heading) {
        heading.textContent = text;
      }
    });
  }

  function applySessionUser(payload) {
    if (!payload || !payload.authenticated) {
      return;
    }
    var name = payload.display_name;
    var profileName = document.querySelector(".nx-profile-btn__meta strong");
    if (profileName && name) {
      profileName.textContent = name;
    }
    updateGreetings(name);
  }

  function initGreeting() {
    var name = null;
    try {
      if (window.GMU && window.GMU.user && window.GMU.user.displayName) {
        name = window.GMU.user.displayName;
      }
    } catch (error) {
      /* window.GMU may not be initialised yet on older cached pages. */
    }
    if (name) {
      updateGreetings(name);
      return;
    }
    fetch("/auth/me", { credentials: "same-origin" })
      .then(function (response) { return response.ok ? response.json() : null; })
      .then(function (payload) { applySessionUser(payload); })
      .catch(function () { /* keep the authored heading when the lookup fails */ });
  }

  function searchResultsRegion() {
    var app = document.querySelector("[data-app-shell]") || document.querySelector(".nx-app");
    if (!app) {
      return null;
    }
    var existing = app.querySelector("[data-search-results]");
    if (existing) {
      return existing;
    }
    var region = document.createElement("section");
    region.className = "nx-search-results";
    region.id = "search-results";
    region.hidden = true;
    var footer = app.querySelector(".nx-footer");
    if (footer && footer.parentNode === app) {
      app.insertBefore(region, footer);
    } else {
      app.appendChild(region);
    }
    return region;
  }

  function renderSearchResults(region, query, type, results) {
    region.hidden = false;
    region.classList.remove("is-loading", "is-error");
    region.setAttribute("data-search-type", type);
    region.setAttribute("data-search-query", query);

    var count = results.length;
    var head = region.querySelector(".nx-search-results__head");
    if (count > 0) {
      region.classList.remove("is-empty");
    } else {
      region.classList.add("is-empty");
    }
    if (!head) {
      head = document.createElement("header");
      head.className = "nx-search-results__head";
      head.innerHTML =
        '<div class="nx-cluster" style="justify-content: space-between; gap: var(--nx-space-3);">' +
        '<p class="nx-search-results__title" data-search-title></p>' +
        '<button class="nx-btn nx-btn--ghost nx-btn--sm" type="button" data-search-clear>Clear</button>' +
        "</div>";
      region.appendChild(head);
    }

    var list = region.querySelector(".nx-search-results__list");
    if (!list) {
      list = document.createElement("ul");
      list.className = "nx-search-results__list";
      region.appendChild(list);
    }

    region.querySelector("[data-search-title]").textContent =
      "Search results · " + query;

    if (count === 0) {
      list.innerHTML =
        '<li class="nx-search-results__empty" data-search-empty>' +
        "No records match your search.</li>";
      return;
    }

    var items = list.querySelectorAll(".nx-search-result");
    items.forEach(function (item) { item.remove(); });

    var fragment = document.createDocumentFragment();
    results.forEach(function (result) {
      var item = document.createElement("li");
      item.className = "nx-search-result";
      var href = resultHref(type);
      var anchor = document.createElement("a");
      anchor.className = "nx-search-result__link";
      anchor.href = href;
      anchor.setAttribute("data-search-result", "true");
      if (href === "#") {
        anchor.setAttribute("aria-disabled", "true");
      }
      var label = document.createElement("span");
      label.className = "nx-search-result__label";
      label.textContent = resultLabel(type, result);
      var meta = document.createElement("span");
      meta.className = "nx-search-result__meta";
      meta.textContent = resultMeta(type, result);
      anchor.appendChild(label);
      anchor.appendChild(meta);
      item.appendChild(anchor);
      fragment.appendChild(item);
    });
    list.appendChild(fragment);

    var empty = list.querySelector("[data-search-empty]");
    if (empty) {
      empty.remove();
    }
  }

  function resultHref(type) {
    if (type === "students") {
      /* Faculty and admin workspaces open the student roster; students only
         ever see their own record, so they get no cross-record link. */
      return role === "student" ? "#" : "students.html";
    }
    if (type === "faculty") {
      return role === "admin" ? "faculty.html" : "#";
    }
    if (type === "courses") {
      /* Students and admins both land on the courses workspace. */
      return "courses.html";
    }
    if (type === "departments") {
      return "departments.html";
    }
    return "#";
  }

  function resultLabel(type, result) {
    if (type === "students") {
      var studentName = ((result.first_name || "") + " " + (result.last_name || "")).trim();
      return studentName || result.usn || "Student record";
    }
    if (type === "faculty") {
      var facultyName = ((result.first_name || "") + " " + (result.last_name || "")).trim();
      return facultyName || result.employee_id || "Faculty member";
    }
    if (type === "courses") {
      var subjectName = (result.subject_name || result.course_name || "").toString();
      var code = (result.subject_code || result.course_code || "").toString();
      return code ? code + " · " + subjectName : subjectName;
    }
    if (type === "departments") {
      var deptName = (result.department_name || result.name || "").toString();
      var deptCode = (result.department_code || result.code || "").toString();
      return deptCode ? deptCode + " · " + deptName : deptName;
    }
    return "Record";
  }

  function resultMeta(type, result) {
    if (type === "students") {
      var parts = [];
      if (result.usn) parts.push(result.usn);
      if (result.course_name) parts.push(result.course_name);
      if (result.email) parts.push(result.email);
      if (result.current_semester) parts.push("Semester " + result.current_semester);
      return parts.join(" · ");
    }
    if (type === "faculty") {
      var fparts = [];
      if (result.employee_id) fparts.push(result.employee_id);
      if (result.designation) fparts.push(result.designation);
      if (result.department_name) fparts.push(result.department_name);
      return fparts.join(" · ");
    }
    if (type === "courses") {
      var cparts = [];
      if (result.semester_number) cparts.push("Semester " + result.semester_number);
      if (result.subject_type) cparts.push(result.subject_type);
      if (result.credits) cparts.push(result.credits + " credits");
      if (result.level) cparts.push(result.level);
      return cparts.join(" · ");
    }
    if (type === "departments") {
      var dparts = [];
      if (result.hod_name) dparts.push("HOD " + result.hod_name);
      if (result.status) dparts.push(result.status);
      return dparts.join(" · ");
    }
    return "";
  }

  function initSearch() {
    var form = document.querySelector("[data-dashboard-search]");
    if (!form) {
      return;
    }
    form.addEventListener("submit", function (event) {
      event.preventDefault();
      var input = form.querySelector("input");
      var query = input ? (input.value || "").trim() : "";
      if (!query) {
        var region = document.querySelector("[data-app-shell]") || document.querySelector(".nx-app");
        var target = region ? region.querySelector("[data-search-results]") : null;
        if (target) {
          target.hidden = true;
          target.classList.remove("is-loading", "is-error", "is-empty");
        }
        return;
      }
      var type = "students";
      var explicit = document.body.getAttribute("data-search-type");
      if (explicit && SEARCH_TYPES[explicit]) {
        type = explicit;
      } else {
        var pageType = DEFAULT_SEARCH_TYPE_BY_PAGE[(document.body.getAttribute("data-page") || "").toLowerCase()];
        if (pageType && SEARCH_TYPES[pageType]) {
          type = pageType;
        }
      }
      var app = document.querySelector("[data-app-shell]") || document.querySelector(".nx-app");
      var region = app ? (app.querySelector("[data-search-results]") || searchResultsRegion()) : null;
      if (!region) {
        return;
      }
      region.hidden = false;
      region.classList.add("is-loading");
      region.classList.remove("is-error");
      fetch("/dashboard/search?q=" + encodeURIComponent(query) + "&type=" + encodeURIComponent(type), {
        credentials: "same-origin",
      })
        .then(function (response) { return response.ok ? response.json() : Promise.reject(new Error("Search failed")); })
        .then(function (payload) { renderSearchResults(region, payload.query || query, payload.type || type, payload.results || []); })
        .catch(function () {
          region.classList.remove("is-loading");
          region.classList.add("is-error");
          var errorText = region.querySelector("[data-search-error-text]");
          if (!errorText) {
            errorText = document.createElement("p");
            errorText.className = "nx-search-results__error";
            errorText.setAttribute("data-search-error-text", "true");
            region.appendChild(errorText);
          }
          errorText.textContent = "Search could not be completed. Please try again.";
        });
    });

    var clearButton = document.querySelector("[data-search-clear]");
    if (clearButton) {
      clearButton.addEventListener("click", function () {
        var form2 = clearButton.closest("form");
        var input2 = document.querySelector("[data-dashboard-search] input");
        if (input2) {
          input2.value = "";
        }
        if (form2) {
          form2.reset();
        }
        var app2 = document.querySelector("[data-app-shell]") || document.querySelector(".nx-app");
        var target2 = app2 ? app2.querySelector("[data-search-results]") : null;
        if (target2) {
          target2.hidden = true;
          target2.classList.remove("is-loading", "is-error", "is-empty");
        }
      });
    }
  }


  function initCollapse() {
    var app = document.querySelector(".nx-app");
    var toggle = document.querySelector("[data-sidebar-collapse]");
    if (!app || !toggle) {
      return;
    }

    var storageKey = "gmu-sidebar-collapsed";
    var stored = null;
    try {
      stored = window.localStorage.getItem(storageKey);
    } catch (error) {
      stored = null;
    }

    function apply(collapsed) {
      app.classList.toggle("is-sidebar-collapsed", collapsed);
      toggle.setAttribute("aria-expanded", collapsed ? "false" : "true");
      toggle.setAttribute("aria-label", collapsed ? "Expand sidebar" : "Collapse sidebar");
      try {
        window.localStorage.setItem(storageKey, collapsed ? "1" : "0");
      } catch (error) {
        /* Storage can be unavailable in private browsing; the toggle still works. */
      }
    }

    apply(stored === "1");

    toggle.addEventListener("click", function () {
      apply(!app.classList.contains("is-sidebar-collapsed"));
    });
  }

  /* ------------------------------------------------------------------------
     Mount
     ------------------------------------------------------------------------ */

  function mount() {
    var app = document.querySelector("[data-app-shell]") || document.querySelector(".nx-app");
    var main = app ? app.querySelector("main") : null;
    if (!app || !main) {
      return;
    }

    document.body.insertAdjacentHTML("afterbegin", SPRITE);
    document.body.insertAdjacentHTML(
      "afterbegin",
      '<a class="nx-skip-link" href="#main-content">Skip to main content</a>'
    );

    var shell = document.createElement("div");
    shell.className = "nx-shell";
    app.insertBefore(shell, main);
    shell.insertAdjacentHTML("afterbegin", buildHeader());
    shell.appendChild(main);
    shell.insertAdjacentHTML("beforeend", buildFooter());

    app.insertAdjacentHTML("afterbegin", buildSidebar() + '<div class="nx-overlay" data-nav-overlay hidden></div>');

    var pageContainer = main.querySelector(".nx-page");
    if (pageContainer) {
      pageContainer.insertAdjacentHTML("afterbegin", buildBreadcrumb());
    }

    initCollapse();
    initGreeting();
    initSearch();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", mount);
  } else {
    mount();
  }
})();
