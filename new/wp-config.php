<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the
 * installation. You don't have to use the web site, you can
 * copy this file to "wp-config.php" and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * MySQL settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://codex.wordpress.org/Editing_wp-config.php
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'cesarari_wp1' );

/** MySQL database username */
define( 'DB_USER', 'cesarari_wp1' );

/** MySQL database password */
define( 'DB_PASSWORD', 'Q.wFluqF76zkZcq9TiK26' );

/** MySQL hostname */
define( 'DB_HOST', '127.0.0.1' );

/** Database Charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The Database Collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'Fa5WIBZItnEpnycVoKLK6hom6BUJ2vZYuVjFskjKhAAM0DADtnk5RcF1uHOtFfMK');
define('SECURE_AUTH_KEY',  'DswUsM9t2DWqRo4pmwMIM37qCm4XWiuR6PAkwFImgWhPUONooOmRBbBDP2gHcGew');
define('LOGGED_IN_KEY',    'EOR5hI87W0YX9ueoqJUsayz6dCL488jpwIhQCDuVD6a4JkdU193mvGTgLm5i61qA');
define('NONCE_KEY',        'VpXPYt8BBo7VDSZR1sYyNWLpM7xBn5cKJodgGLtwdedjLomtoJZe7TfW1zlRKQvy');
define('AUTH_SALT',        'o6XVpwpqwKrZ8FLJ8AJ0wA0OBpH9XRY2bUwebJ3vrdf0vI52iA8Af9MjesV10Jtn');
define('SECURE_AUTH_SALT', 'yxeRXeB4maQBRc9jXjZ8O9tNZyUEfTMAIXcpw1kIuW6BubLp7hSWS2jSSMRZr8VI');
define('LOGGED_IN_SALT',   'bmFovi431rU8QEvCVtGFkqMnhJdRsav8JPAsbYcnxMFCfwT0gIl28KUjQWnulCjI');
define('NONCE_SALT',       'rwNZ6vd1qniBgiH2HOw6kGLZbwgt3vaBVZK9gVn2sGWd4l2LV0UHNz944bkn1TCN');

/**
 * Other customizations.
 */
define('FS_METHOD','direct');
define('FS_CHMOD_DIR',0755);
define('FS_CHMOD_FILE',0644);
define('WP_TEMP_DIR',dirname(__FILE__).'/wp-content/uploads');

/**
 * Turn off automatic updates since these are managed externally by Installatron.
 * If you remove this define() to re-enable WordPress's automatic background updating
 * then it's advised to disable auto-updating in Installatron.
 */
define('AUTOMATIC_UPDATER_DISABLED', true);


/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the Codex.
 *
 * @link https://codex.wordpress.org/Debugging_in_WordPress
 */
define( 'WP_DEBUG', false );

/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', dirname( __FILE__ ) . '/' );
}

/** Sets up WordPress vars and included files. */
require_once( ABSPATH . 'wp-settings.php' );
