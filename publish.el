(defconst site-root
  (file-name-directory (or load-file-name buffer-file-name)))

(require 'ox-publish)
(require 'ox-html)

(defvar site-root (file-name-directory (or load-file-name buffer-file-name)))

(add-to-list 'load-path (expand-file-name "lisp" site-root))
(require 'site-extras)

;; Set global bibliography for org-cite
(setq org-cite-global-bibliography '("~/notes/references.bib"))

;; Use custom CSL style (no parentheses around inline citations)
(setq org-cite-csl-styles-dir (expand-file-name "assets" site-root))
(setq org-cite-export-processors '((html . (csl "citation-style.csl"))
                                   (t . (csl "citation-style.csl"))))

;; Convert local asset paths to web-root-relative paths on export
(defun my/fix-asset-paths (output backend info)
  "Convert local asset paths to web-root-relative paths."
  (when (eq backend 'html)
    (replace-regexp-in-string
     (concat "file://" (regexp-quote (expand-file-name "assets/" site-root)))
     "/assets/"
     output)))

(add-to-list 'org-export-filter-final-output-functions #'my/fix-asset-paths)

;; Navigation HTML
(defconst site-nav
  "<nav>
<a href=\"/\">Home</a>
<a href=\"/blog/\">Blog</a>
<a href=\"/projects/\">Projects</a>
<a href=\"/publications/\">Publications</a>
<a href=\"/cv/\">CV</a>
</nav>")

;; Shared publishing settings
(defconst site-html-settings
  `(:publishing-function org-html-publish-to-html
    :with-title t
    :with-toc nil
    :section-numbers nil
    :with-author nil
    :with-creator nil
    :with-date nil
    :time-stamp-file nil
    :html-head "<link rel=\"stylesheet\" href=\"/assets/css/style.css\" type=\"text/css\"/>
                <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/favicons/favicon.svg\"/>
                <link rel=\"alternate icon\" href=\"/assets/favicons/favicon.ico\"/>
                <link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"/assets/favicons/favicon-32x32.png\"/>
                <link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"/assets/favicons/favicon-16x16.png\"/>"
    :html-preamble ,site-nav
    :html-postamble nil
    :html-head-include-default-style nil
    :html-head-include-scripts nil))

;; Blog-specific settings (includes date)
(defconst site-blog-settings
  `(:publishing-function org-html-publish-to-html
    :with-title t
    :with-toc nil
    :section-numbers nil
    :with-author nil
    :with-creator nil
    :with-date t
    :time-stamp-file nil
    :html-head "<link rel=\"stylesheet\" href=\"/assets/css/style.css\" type=\"text/css\"/>
                <link rel=\"icon\" type=\"image/svg+xml\" href=\"/assets/favicons/favicon.svg\"/>
                <link rel=\"alternate icon\" href=\"/assets/favicons/favicon.ico\"/>
                <link rel=\"icon\" type=\"image/png\" sizes=\"32x32\" href=\"/assets/favicons/favicon-32x32.png\"/>
                <link rel=\"icon\" type=\"image/png\" sizes=\"16x16\" href=\"/assets/favicons/favicon-16x16.png\"/>"
    :html-preamble ,site-nav
    :html-postamble nil
    :html-head-include-default-style nil
    :html-head-include-scripts nil))

(setq org-publish-project-alist
      `(("site-pages"
         :base-directory ,(expand-file-name "org" site-root)
         :publishing-directory ,(expand-file-name "docs" site-root)
         :recursive t
         :exclude "blog/\\|projects/"  ; handled separately
         ,@site-html-settings)

        ("site-blog"
         :base-directory ,(expand-file-name "org/blog" site-root)
         :publishing-directory ,(expand-file-name "docs/blog" site-root)
         :recursive t
         :auto-sitemap t
         :sitemap-title "Blog"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         ,@site-blog-settings)

        ("site-projects"
         :base-directory ,(expand-file-name "org/projects" site-root)
         :publishing-directory ,(expand-file-name "docs/projects" site-root)
         :recursive t
         :auto-sitemap t
         :sitemap-title "Projects"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         ,@site-html-settings)

        ("site-assets"
         :base-directory ,(expand-file-name "assets" site-root)
         :base-extension "css\\|js\\|png\\|svg\\|jpg\\|gif\\|pdf\\|webp\\|mp4\\|html"
         :recursive t
         :publishing-directory ,(expand-file-name "docs/assets" site-root)
         :publishing-function org-publish-attachment)

        ("site" :components ("site-blog" "site-projects" "site-pages" "site-assets"))))
