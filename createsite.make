core = 7.x
api = 2

; Drupal Core
projects[] = drupal

; Dev Modules
projects[backup_migrate] = 3.x-dev
projects[elysia_cron] = 2.x-dev
projects[flexslider] = 2.x-dev
projects[feeds] = 2.x-dev
projects[media] = 2.x-dev
projects[media_browser_plus] = 3.x-dev
projects[multiform] = 2.x-dev
projects[views_tree] = 2.x-dev


; Prod Modules
projects[] = admin_menu
projects[] = advanced_help
projects[] = better_formats
projects[] = blockreference
projects[] = breakpoints
projects[] = calendar
projects[] = ckeditor
projects[] = colorbox
projects[] = context
projects[] = ctools
projects[] = date
projects[] = devel
projects[] = disqus
projects[] = ds
projects[] = entity
projects[] = entity_rules
projects[] = entity2text
projects[] = entityform
projects[] = entityreference
projects[] = features
projects[] = features_extra
projects[] = field_group
projects[] = field_placeholder
projects[] = file_entity
projects[] = fontyourface
projects[] = fpa
projects[] = google_analytics
projects[] = imagecache_actions
projects[] = imagecache_token
projects[] = imce
projects[] = imce_plupload
projects[] = inline_entity_form
projects[] = job_scheduler
projects[] = jquery_update
projects[] = libraries
projects[] = link
projects[] = linkit
projects[] = logintoboggan
projects[] = menu_block
projects[] = menu_position
projects[] = metatag
projects[] = module_filter
projects[] = nodeformsettings
projects[] = nodequeue
projects[] = nodereference_url
projects[] = pathauto
projects[] = pathologic
projects[] = picture
projects[] = plupload
projects[] = prod_check
projects[] = references
projects[] = rules
projects[] = security_review
projects[] = services
projects[] = session_api
projects[] = special_menu_items
projects[] = strongarm
projects[] = term_reference_tree
projects[] = token
projects[] = transliteration
projects[] = uuid
projects[] = uuid_features
projects[] = views
projects[] = views_bulk_operations

; Themes
projects[omega][type] = theme
projects[omega][version] = 4.3
projects[omega][download][type] = git
projects[omega][download][url] = http://git.drupal.org/project/omega.git
projects[omega][download][branch] = 7.x-4.x
projects[omega_hackrobats][type] = theme
projects[omega_hackrobats][version] = 1.0
projects[omega_hackrobats][download][type] = git
projects[omega_hackrobats][download][url] = http://github.com/randull/omega_hackrobats.git
projects[shiny][type] = theme
projects[shiny][version] = 1.6
projects[shiny][download][type] = git
projects[shiny][download][url] = http://git.drupal.org/project/shiny.git
projects[shiny][download][branch] = 7.x-1.x

; Libraries
libraries[ckeditor][directory_name] = "ckeditor"
libraries[ckeditor][destination] = "libraries"
libraries[ckeditor][download][type] = "get"
libraries[ckeditor][download][url] = "http://download.cksource.com/CKEditor/CKEditor/CKEditor%204.2.2/ckeditor_4.2.2_standard.tar.gz"
libraries[colorbox][directory_name] = "colorbox"
libraries[colorbox][destination] = "libraries"
libraries[colorbox][download][type] = "get"
libraries[colorbox][download][url] = "https://github.com/jackmoore/colorbox/archive/master.tar.gz"
libraries[flexslider][directory_name] = "flexslider"
libraries[flexslider][destination] = "libraries"
libraries[flexslider][download][type] = "get"
libraries[flexslider][download][url] = "https://codeload.github.com/woothemes/FlexSlider/zip/version/2.2"
libraries[html5shiv][directory_name] = "html5shiv"
libraries[html5shiv][destination] = "libraries"
libraries[html5shiv][download][type] = "get"
libraries[html5shiv][download][url] = "https://github.com/fubhy/html5shiv/archive/master.zip"
libraries[matchmedia][directory_name] = "matchmedia"
libraries[matchmedia][destination] = "libraries"
libraries[matchmedia][download][type] = "get"
libraries[matchmedia][download][url] = "https://github.com/fubhy/matchmedia/archive/master.zip"
libraries[pie][directory_name] = "pie"
libraries[pie][destination] = "libraries"
libraries[pie][download][type] = "get"
libraries[pie][download][url] = "https://github.com/fubhy/pie/archive/master.zip"
libraries[placeholder][directory_name] = "placeholder"
libraries[placeholder][destination] = "libraries"
libraries[placeholder][download][type] = "get"
libraries[placeholder][download][url] = "https://github.com/jamesallardice/Placeholders.js/archive/master.zip"
libraries[plupload][directory_name] = "plupload"
libraries[plupload][destination] = "libraries"
libraries[plupload][download][type] = "get"
libraries[plupload][download][url] = "https://github.com/moxiecode/plupload/archive/v1.5.8.tar.gz"
libraries[respond][directory_name] = "respond"
libraries[respond][destination] = "libraries"
libraries[respond][download][type] = "get"
libraries[respond][download][url] = "https://github.com/fubhy/respond/archive/master.zip"
libraries[s3-php5-curl][directory_name] = "s3-php5-curl"
libraries[s3-php5-curl][destination] = "libraries"
libraries[s3-php5-curl][download][type] = "get"
libraries[s3-php5-curl][download][url] = "https://github.com/tpyo/amazon-s3-php-class/archive/master.zip"
libraries[selectivizr][directory_name] = "selectivizr"
libraries[selectivizr][destination] = "libraries"
libraries[selectivizr][download][type] = "get"
libraries[selectivizr][download][url] = "https://github.com/fubhy/selectivizr/archive/master.zip"
libraries[simplepie][directory_name] = "simplepie"
libraries[simplepie][destination] = "libraries"
libraries[simplepie][download][type] = "get"
libraries[simplepie][download][url] = "http://simplepie.org/downloads/simplepie_1.3.1.compiled.php"



; Custom Install Profile
projects[createsite][type] = "profile"
projects[createsite][download][type] = "git"
projects[createsite][download][url] = "git://github.com/randull/createsite.git"
