;;; site-extras.el --- post dates + extensionless URLs for the org-publish site  -*- lexical-binding: t; -*-

;; Three independent pieces.  Load this from publish.el (or config.org) before
;; calling `org-publish'.  Each section says where it hooks in.

;;; ---------------------------------------------------------------------------
;;; 1a. Date under the <h1> on a post page
;;; ---------------------------------------------------------------------------
;;
;; Write dates as active timestamps so they can be reformatted:
;;
;;     #+DATE: <2026-05-15>
;;
;; A bare "#+DATE: 2026-05-15" is a plain string and `org-export-get-date'
;; will hand it back unformatted; the timestamp form is what lets you choose
;; the display format in one place.
;;
;; ox-html emits the title as `<h1 class="title">...</h1>' inside
;; `org-html-template', not in the body, so a body filter can't see it.  The
;; final-output filter is the smallest thing that can.

(defvar jo/post-date-format "%B %-d, %Y"
  "`format-time-string' spec used for the date line on post pages.")

(defvar jo/dated-page-regexp "/org/\\(blog\\|projects\\)/"
  "Only pages whose source path matches this get a date line.
Keeps the filter from stamping the homepage and CV.")

(defun jo/html-date-under-title (output backend info)
  "Insert a date line after the exported title in OUTPUT."
  (let ((file (plist-get info :input-file)))
    (if (not (and (org-export-derived-backend-p backend 'html)
                  file
                  (string-match-p jo/dated-page-regexp file)
                  (string-match "</h1>" output)))
        output
      (let* ((end (match-end 0))
             (human (org-export-get-date info jo/post-date-format))
             (machine (org-export-get-date info "%Y-%m-%d")))
        (if (not (org-string-nw-p human))
            output
          (concat (substring output 0 end)
                  (format "\n<p class=\"post-date\"><time datetime=\"%s\">%s</time></p>"
                          machine human)
                  (substring output end)))))))

(add-to-list 'org-export-filter-final-output-functions #'jo/html-date-under-title)

;;; ---------------------------------------------------------------------------
;;; 1b. Dates on the blog index
;;; ---------------------------------------------------------------------------
;;
;; Assumes the index is org-publish's generated sitemap.  In the "blog"
;; project spec:
;;
;;     :auto-sitemap t
;;     :sitemap-filename "index.org"
;;     :sitemap-title "Blog"
;;     :sitemap-style 'list
;;     :sitemap-sort-files 'anti-chronologically
;;     :sitemap-function #'jo/blog-sitemap
;;     :sitemap-format-entry #'jo/blog-sitemap-entry
;;
;; `org-publish-find-date' reads #+DATE: from the source file and falls back
;; to the file's mtime if there isn't one — so a post with no #+DATE: will
;; silently show "whenever I last touched it".  Worth knowing.

(defun jo/blog-sitemap-entry (entry style project)
  "Format one blog index ENTRY as date + title."
  (cond
   ((not (directory-name-p entry))
    (format "@@html:<span class=\"post-date\">@@%s@@html:</span>@@ [[file:%s][%s]]"
            (format-time-string "%Y-%m-%d" (org-publish-find-date entry project))
            entry
            (org-publish-find-title entry project)))
   ((eq style 'tree) (file-name-nondirectory (directory-file-name entry)))
   (t entry)))

(defun jo/blog-sitemap (title list)
  "Wrap the generated LIST in a container so CSS can grab it."
  (concat "#+TITLE: " title "\n\n"
          "#+attr_html: :class post-list\n"
          (org-list-to-org list)
          "\n"))

;;; ---------------------------------------------------------------------------
;;; 3. Extensionless internal links
;;; ---------------------------------------------------------------------------
;;
;; GitHub Pages already serves foo.html at /foo with no configuration, so the
;; only thing to fix is the .html that org writes into hrefs.
;;
;; NOTE: this touches links org transcodes.  Anything you hand-wrote in
;; :html-preamble as raw HTML (a nav bar, say) has to have its .html removed
;; by hand.

(defun jo/clean-href (href)
  "Strip a trailing .html from HREF, preserving any #fragment.
Leaves URLs with a scheme (https:, mailto:) alone."
  (cond
   ((string-match-p "\\`[a-zA-Z][-+.a-zA-Z0-9]*:" href) href)
   ((string-match "\\`\\(.*?\\)\\.html\\(#.*\\)?\\'" href)
    (let ((base (match-string 1 href))
          (frag (or (match-string 2 href) "")))
      (concat (if (string-suffix-p "index" base)
                  ;; .../blog/index.html -> .../blog/
                  (substring base 0 (- (length base) (length "index")))
                base)
              frag)))
   (t href)))

(defun jo/strip-html-ext (link backend info)
  "Rewrite hrefs in the exported LINK to drop .html."
  (if (not (org-export-derived-backend-p backend 'html))
      link
    (replace-regexp-in-string
     "href=\"\\([^\"]*\\)\""
     (lambda (m) (format "href=\"%s\"" (jo/clean-href (match-string 1 m))))
     link t t)))

(add-to-list 'org-export-filter-link-functions #'jo/strip-html-ext)

(provide 'site-extras)
