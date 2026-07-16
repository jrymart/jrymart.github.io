(defconst site-root
  (file-name-directory (or load-file-name buffer-file-name)))

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
    :html-head "<link rel=\"stylesheet\" href=\"/assets/css/style.css\" type=\"text/css\"/>"
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
    :html-head "<link rel=\"stylesheet\" href=\"/assets/css/style.css\" type=\"text/css\"/>"
    :html-preamble ,site-nav
    :html-postamble nil
    :html-head-include-default-style nil
    :html-head-include-scripts nil))

(setq org-publish-project-alist
      `(("site-pages"
         :base-directory ,(expand-file-name "org" site-root)
         :publishing-directory ,(expand-file-name "public" site-root)
         :recursive t
         :exclude "blog/\\|projects/"  ; handled separately
         ,@site-html-settings)

        ("site-blog"
         :base-directory ,(expand-file-name "org/blog" site-root)
         :publishing-directory ,(expand-file-name "public/blog" site-root)
         :recursive t
         :auto-sitemap t
         :sitemap-title "Blog"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         ,@site-blog-settings)

        ("site-projects"
         :base-directory ,(expand-file-name "org/projects" site-root)
         :publishing-directory ,(expand-file-name "public/projects" site-root)
         :recursive t
         :auto-sitemap t
         :sitemap-title "Projects"
         :sitemap-filename "index.org"
         :sitemap-sort-files anti-chronologically
         ,@site-html-settings)

        ("site-assets"
         :base-directory ,(expand-file-name "assets" site-root)
         :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|webp\\|mp4"
         :recursive t
         :publishing-directory ,(expand-file-name "public/assets" site-root)
         :publishing-function org-publish-attachment)

        ("site" :components ("site-blog" "site-projects" "site-pages" "site-assets"))))
