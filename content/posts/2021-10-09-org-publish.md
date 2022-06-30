---
title: How I Build My Site
date: <2021-10-09 Sat>
---

I use Emacs to build my site from a collection of org files into a series of web pages. The current setup is developed on a Mac with a Doom Emacs distribution.

## Intro
This is the commented header section that documents the following file as a configuration file that publishes a series of org files as html webpages.

```elisp
;;; build-site.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2021 Francisco Cornejo-Garcia
;;
;; Author: Francisco Cornejo-Garcia <https://github.com/franciscornejog>
;; Maintainer: Francisco Cornejo-Garcia <franciscornejog@gmail.com>
;; Created: October 02, 2021
;; Modified: October 02, 2021
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/franciscornejogarcia/build-site
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  Description
;;
;;; Code:

;; load publishing system
(require 'ox-publish)
```

## Variables
```elisp
(defvar build-site-html-head
    "<meta charset=\"utf-8\">
    <meta name=\"HandheldFriendly\" content=\"True\">
    <meta name=\"MobileOptimized\" content=\"320\">
    <meta name=\"robots\" content=\"index,follow\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
    <title>Francisco Cornejo-Garcia</title>
    <link href=\"static/css/normalize.css\" rel=\"stylesheet\" type=\"text/css\">
    <link href=\"static/css/main.css\"rel=\"stylesheet\" type=\"text/css\">")

(defvar build-site-html-preamble
  "<header>
    <div class=\"with-image\">
        <img src=\"static/img/profile/profile-1024.jpeg\">
        <p>Francisco Cornejo-Garcia <span class=\"tagline\">RIT | Computer Science</p>
    </div>
    <nav>
        <a href=\"index.html\">About</a>
        <a href=\"posts.html\">Posts</a>
    </nav>
</header>")

(defvar build-site-html-postamble
"<footer>
    <p>Copyright 2021 Francisco Cornejo-Garcia  All Rights Reserved.</p>
    <p>Available under <a href=\"https://creativecommons.org/licenses/by-sa/3.0/us/\">
        Creative Commons Attribution ShareAlike</a>.
    </p>
 </footer>")
```

## Convert org links to connect to HTML pages
```elisp
(defun build-site-org-export-convert-txt-links (backend)
  "Convert all text links to html links in the BACKEND."
  (cond ((string= backend "html")
  (let ((txt-regex "\\[file:\\(.*\\)\.txt\\]"))
    (while (re-search-forward txt-regex nil t)
      (build-site-convert-txt-link (match-string 1)))))))
(defun build-site-convert-txt-link (name)
  "Convert a NAME of a text link into an html link."
  (replace-match (concat "[file:" name ".html]")))
(add-hook 'org-export-before-processing-hook #'build-site-org-export-convert-txt-links)
```

## Set default parameters
```elisp
(setq org-html-validation-link nil            ;; remove validate link
      org-html-head-include-scripts nil       ;; remove default scripts
      org-html-head-include-default-style nil ;; remove default styles
      org-html-head build-site-html-head
      org-html-preamble build-site-html-preamble
      org-html-postamble build-site-html-postamble
      org-html-coding-system 'utf-8-unix
      org-html-metadata-timestamp-format "%d %m %Y"
      org-html-htmlize-output-type 'css
      org-html-doctype "html5"
      org-html-html5-fancy t)
```

## Publishing Rules
```elisp
;; define publishing project
(setq org-publish-project-alist
      (list
       (list "franciscornejog"
             :base-extension "txt"
             :base-directory "content"
             :publishing-directory "public"
             :publishing-function 'org-html-publish-to-html
             :htmlized-source t       ;; enable htmlize
             :with-date t
             :with-author nil         ;; remove author name
             :with-toc nil            ;; remove table of contents
             :section-numbers nil     ;; remove section numbers
             :time-stamp-file nil)    ;; remove time stamp
       (list "posts"
             :recursive t
             :base-directory "content/posts"
             :base-extension "txt"
             :publishing-directory "public"
             :publishing-function 'org-html-publish-to-html
             :htmlized-source t       ;; enable htmlize
             :with-date t
             :with-toc nil            ;; remove table of contents
             :section-numbers nil     ;; remove section numbers
             :time-stamp-file t       ;; remove time stamp
             :auto-sitemap t
             :sitemap-title "Posts"
             :sitemap-filename "posts.txt"
             :sitemap-sort-files 'anti-chronologically
             :sitemap-style 'list)
       (list "static"
             :recursive t
             :base-directory "static"
             :base-extension "css\\|jpg\\|jpeg"
             :publishing-directory "public/static"
             :publishing-function 'org-publish-attachment)))
```

After generating all the files, the follow block will publish these files to their directories and send a message once the build is complete.

```elisp
;; generate site output
(org-publish-all t)
(message "Build complete!")
;;; build-site.el ends here
```
