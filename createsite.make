core = 7.x
api = 2

; Drupal Core
projects[drupal][type] = core
projects[drupal][version] = 7.23
projects[drupal][download][type] = get
projects[drupal][download][url] = http://ftp.drupal.org/files/projects/drupal-7.23.tar.gz

; Modules
projects[] = admin_menu
projects[] = breakpoints
projects[] = ckeditor
projects[] = ctools
projects[] = flexslider
projects[] = libraries
projects[] = module_filter
projects[] = picture
projects[] = prod_check
projects[] = security_review
projects[] = views

; Custom Install Profile
projects[hackrobats][type] = "profile"
projects[hackrobats][download][type] = "git"
projects[hackrobats][download][url] = "git://github.com/randull/createsite.git"
