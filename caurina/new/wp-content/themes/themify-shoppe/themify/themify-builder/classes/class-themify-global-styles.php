<?php
/**
 * This file defines Global Styles
 *
 * Themify_Global_Styles class register post type for Global Styles and load them
 *
 *
 * @package    Themify_Builder
 * @subpackage Themify_Builder/classes
 */

if( !class_exists( 'Themify_Global_Styles' ) ) {
	/**
	 * The Global Styles class.
	 *
	 * This class register post type for Global Styles and load them.
	 *
	 *
	 * @package    Themify_Builder
	 * @subpackage Themify_Builder/classes
	 * @author     Themify
	 */
	class Themify_Global_Styles
	{

		/**
		 * Post Type Global Styles Object.
		 *
		 * @access static
		 * @var object $globalStyle .
		 */
		static $globalStyle;

		/**
		 * Post Type Global Styles Object.
		 *
		 * @access private
		 * @var object $used_styles .
		 */
		private static $used_styles = false;


		/**
		 * Constructor
		 *
		 * @access public
		 */
		public function __construct() {
			self::register_global_style();
			if ( is_admin() ) {
				add_filter( 'themify_post_types', array( $this, 'extend_post_types' ) );
				add_action( 'wp_ajax_tb_save_custom_global_style', array( $this, 'save_custom_global_style_ajaxify' ), 10 );
				add_action( 'wp_ajax_tb_delete_global_style', array( $this, 'delete_global_style_ajaxify' ), 10 );
				add_action( 'wp_ajax_tb_restore_global_style', array( $this, 'restore_global_style_ajaxify' ), 10 );
				add_filter( 'themify_builder_post_types_support', array( $this, 'add_builder_support' ) );
				add_action( 'admin_enqueue_scripts', array( $this, 'enqueue_admin_scripts' ) );
				add_action( 'admin_init', array( $this, 'export' ) );
				add_action( 'wp_ajax_tb_save_as_new_global_style', array( $this, 'save_as_new_ajax' ), 10 );
				add_action( 'wp_ajax_tb_update_global_style', array( $this, 'update_live' ), 10 );
				add_action( 'wp_ajax_tb_get_gs_posts', array( $this, 'get_posts_ajax' ), 10 );
				add_action( 'wp_ajax_tb_import_gs_posts_ajax', array( $this, 'import_posts_ajax' ), 10 );
			}
			add_filter( 'template_include', array( $this, 'template_singular_global_style' ) );
			add_filter( 'themify_builder_ajax_front_vars', array( $this, 'localize_data' ) );
			add_filter( 'themify_builder_ajax_admin_vars', array( $this, 'localize_data' ) );
			add_filter( 'themify_generate_style_vars', array( $this, 'localize_data' ) );
			add_filter( 'themify_builder_module_container_props', array( $this, 'add_global_style_class' ), 10, 2 );
		}

		/**
		 * Register Global Style Custom Post Type
		 *
		 * @access static
		 */
		static function register_global_style() {
			if ( !class_exists( 'CPT' ) ) {
				include THEMIFY_BUILDER_LIBRARIES_DIR . '/CPT.php';
			}

			// create a template custom post type
			self::$globalStyle = new CPT( array(
				'post_type_name' => 'tglobal_style',
				'singular' => __( 'Global Style', 'themify' ),
				'plural' => __( 'Global Styles', 'themify' )
			), array(
				'supports' => array( 'title' ),
				'exclude_from_search' => true,
				'show_in_nav_menus' => false,
				'show_in_menu' => false,
				'public' => true,
				'has_archive' => false
			) );

			// define the columns to appear on the admin edit screen
			self::$globalStyle->columns( array(
				'title' => __( 'Title', 'themify' )
			) );

			// use "pages" icon for post type
			self::$globalStyle->menu_icon( 'dashicons-admin-page' );

			add_post_type_support( self::$globalStyle->post_type_name, 'revisions' );
		}

		/**
		 * Includes this custom post to array of cpts managed by Themify
		 *
		 * @access static
		 * @param array $types
		 * @return array
		 */
		static function extend_post_types( $types ) {
			$cpts = array( self::$globalStyle->post_type_name );
			return array_merge( $types, $cpts );
		}

		/**
		 * Global Style for Template (Editor).
		 *
		 * @access static
		 * @param stirng $original_template
		 * @return string
		 */
		static function template_singular_global_style( $original_template ) {
			if ( is_singular( array( self::$globalStyle->post_type_name ) ) ) {
				$templatefilename = 'template-builder-editor.php';

				$return_template = locate_template(
					array(
						trailingslashit( 'themify-builder/templates' ) . $templatefilename
					)
				);

				// Get default template
				if ( !$return_template ) {
					$return_template = THEMIFY_BUILDER_TEMPLATES_DIR . '/' . $templatefilename;
				}
				return $return_template;
			} else {
				return $original_template;
			}
		}

		/**
		 * Handle Ajax request for add new Global Style
		 *
		 * @access static
		 */
		static function save_custom_global_style_ajaxify() {

			check_ajax_referer( 'tb_load_nonce', 'nonce' );
			$data = $response = array();
			if ( isset( $_POST['form_data'] ) ) {
				parse_str( $_POST['form_data'], $data );
				$insert_post = self::add_new( $data );
				if ( false === $insert_post ) {
					$response['status'] = 'failed';
					$response['msg'] = __( 'Something went wrong', 'themify' );
				} else {
					$response['status'] = 'success';
					$response['url'] = $insert_post['url'] . '#builder_active';
				}
			}
			wp_send_json( $response );
		}

		/**
		 * Handle Ajax request for save as new global style from a module
		 *
		 * @access static
		 */
		static function save_as_new_ajax() {

			check_ajax_referer( 'tb_load_nonce', 'tb_load_nonce' );
			if ( empty( $_POST['title'] ) || empty( $_POST['type'] ) || empty( $_POST['styles'] ) ) {
				return false;
			}
			$args = array(
				'style-name' => $_POST['title'],
				'style-type' => $_POST['type'],
				'styles' => $_POST['styles']
			);
			$insert_post = self::add_new( $args );
			if ( false === $insert_post ) {
				$response['status'] = 'failed';
				$response['msg'] = __( 'Something went wrong', 'themify' );
			} else {
				$response['status'] = 'success';
				$response['post_data'] = $insert_post;
				$response['msg'] = __( 'Global Style has been saved!', 'themify' );
			}
			wp_send_json( $response );
		}

		/**
		 * Handle Ajax request for updating a global style
		 *
		 * @access static
		 */
		static function update_live() {

			check_ajax_referer( 'tb_load_nonce', 'tb_load_nonce' );
			if ( empty( $_POST['id'] ) || empty( $_POST['data'] ) ) {
				return false;
			}
			global $ThemifyBuilder_Data_Manager;
			$ThemifyBuilder_Data_Manager->save_data( $_POST['data'], $_POST['id'] );
			$response['status'] = 'success';
			wp_send_json( $response );
		}

		/**
		 * Handle Ajax request for get global style posts
		 *
		 * @access static
		 */
		static function get_posts_ajax() {

			check_ajax_referer( 'tb_load_nonce', 'tb_load_nonce' );
			$loaded = !empty( $_POST['loaded'] ) ? $_POST['loaded'] : array();
			$args = array(
				'limit' => 10
			, 'data' => true
			, 'loaded' => $loaded
			);
			$globalStyles = self::get_global_styles( $args );
			wp_send_json( $globalStyles );
		}

		/**
		 * Insert new Global Style
		 *
		 * @access static
		 * @param array $args
		 * @return Mixed return false if fails or array of info about inserted post if success
		 */
		public static function add_new( $args,$action = 'new' ) {

			if ( empty( $args['style-name'] ) ) {
				return false;
			}
			$name = sanitize_text_field( $args['style-name'] );
			$type = sanitize_text_field( $args['style-type'] );
			$type = 'subrow' === $type ? 'row' : $type;
			$type = 'subcolumn' === $type ? 'column' : $type;
			$module_type = 'row' === $type || 'column' === $type ? 'text' : $type;
			global $ThemifyBuilder_Data_Manager;
			$module = isset( Themify_Builder_Model::$modules[ $module_type ] ) ? Themify_Builder_Model::$modules[ $module_type ] : null;
			$rowStyling = $colStyling = $moduleStyling = '{"global_styles":" "}';
			if ( is_null( $module ) ) {
				$modules = Themify_Builder_Model::get_modules();
				require_once $modules[ $module_type ]['dirname'] . '/' . $modules[ $module_type ]['basename'];
				$module = Themify_Builder_Model::$modules[ $module_type ];
			}
			$default = $module->get_default_settings();
			$default = is_array( $default ) ? $default : array();
			if ( isset( $default['content_text'] ) && 'text' === $module_type ) {
				$default['content_text'] = '<h1>Heading 1</h1><h2>Heading 2</h2><h3>Heading 3</h3><h4>Heading 4</h4><p>This is a sample Text module.</p>';
			}
			if ( !empty( $args['styles'] ) ) {
				switch ( $type ) {
					case 'row':
						$rowStyling = json_encode( $args['styles'] );
						break;
					case 'column':
						$colStyling = json_encode( $args['styles'] );
						break;
					default:
						$args['styles'] = array_merge( $default, $args['styles'] );
						$moduleStyling = json_encode( $args['styles'] );
				}
			} else {
				$moduleStyling = json_encode( $default );
			}
			if ( 'row' === $type || 'column' === $type ) {
				$moduleStyling = json_encode( $default );
			}
			$id = uniqid();
			$builder_content = '[{"row_order":"0","element_id":"row' . $id . '","styling":' . $rowStyling . ',"cols":[{"column_order":"0","element_id":"col' . $id . '","grid_class":"col-full","styling":' . $colStyling . ',"modules":[{"element_id":"mod' . $id . '","mod_name":"' . $module_type . '","mod_settings":' . $moduleStyling . '}]}]}]';
			if('import' === $action){
				 $new_id = $args['id'];
				update_post_meta( $new_id, 'themify_global_style_type', $type );
            }else{
				$new_id = wp_insert_post( array(
					'post_status' => 'publish',
					'post_type' => self::$globalStyle->post_type_name,
					'post_title' => $name,
					'meta_input' => array(
						'themify_global_style_type' => $type,
						'hide_page_title' => 'yes'
					),
				) );
			}
			if ( !is_wp_error( $new_id ) ) {
				$ThemifyBuilder_Data_Manager->save_data( $builder_content, $new_id );
				$post_slug = !empty( $args['slug'] ) ? $args['slug'] : 'tb_gs' . $new_id . substr( uniqid(), 0, 3 );
				wp_update_post( array(
					'ID' => $new_id,
					'post_name' => $post_slug
				) );
				global $ThemifyBuilder;
				if('import' === $action){
				    $result = array(
				            'builder_data'=>$ThemifyBuilder->get_builder_data( $new_id ),
				            'gsType'=>$type
                    );
                }else{
					$result = array(
						'id' => $new_id,
						'class' => $post_slug,
						'title' => $name,
						'type' => $type,
						'url' => get_post_permalink( $new_id ),
						'data' => $ThemifyBuilder->get_builder_data( $new_id ),
					);
                }
			} else {
				//there was an error in the post insertion,
				$result = false;
			}
			return $result;
		}

		/**
		 * Add Builder support to Global Style post type.
		 * @param array $post_types
		 * @access static
		 * @return array
		 */
		static function add_builder_support( $post_types ) {
			$post_types['tglobal_style'] = 'tglobal_style';

			return $post_types;
		}

		/**
		 * Return Global Styles page content
		 *
		 * @access static
		 * @return String
		 */
		static function page_content() {
			$page_status = empty( $_GET['status'] ) ? 'publish' : $_GET['status'];
			$args = array(
				'preview' => true,
				'status' => $page_status,
				'limit' => 20,
				'paged' => isset( $_GET['pagenum'] ) ? absint( $_GET['pagenum'] ) : 1
			);
			if ( !empty( $_GET['s'] ) ) {
				$args['search'] = sanitize_text_field( $_GET['s'] );
			}
			$globalStyles = self::get_global_styles( $args );
			if ( !empty( $globalStyles ) ) {
				wp_enqueue_style( 'themify-builder-style', themify_enque( THEMIFY_BUILDER_URI . '/css/themify-builder-style.css' ), null, THEMIFY_VERSION );
				if ( is_rtl() ) {
					wp_enqueue_style( 'themify-builder-style-rtl', themify_enque( THEMIFY_BUILDER_URI . '/css/themify-builder-style-rtl.css' ), null, THEMIFY_VERSION );
				}
				wp_register_script( 'themify-main-script', themify_enque( THEMIFY_URI . '/js/main.js' ), null, THEMIFY_VERSION, true );
				global $ThemifyBuilder;
				$ThemifyBuilder->footer_js();
				themify_load_main_script();
				wp_enqueue_script( 'themify-builder-js', themify_enque( THEMIFY_BUILDER_URI . '/js/themify.builder.script.js' ), null, THEMIFY_VERSION, true );
			}
			// Enqueue media scripts
			wp_enqueue_media();
			// Plupload
			wp_enqueue_script( 'plupload-all' );
			wp_enqueue_script( 'themify-plupload' );
			$button = themify_get_uploader( 'tb_gs_import', array(
					'label' => __( 'Import', 'themify' ),
					'preset' => false,
					'preview' => false,
					'tomedia' => false,
					'topost' => '',
					'fields' => '',
					'featured' => '',
					'message' => '',
					'fallback' => '',
					'dragfiles' => false,
					'confirm' => __( 'This will import the global style. Press OK to continue, Cancel to stop.', 'themify' ),
					'medialib' => false,
					'formats' => 'txt',
					'type' => '',
					'action' => 'tb_import_gs_posts_ajax',
					'button_class' => 'page-title-action',
				)
			);
			ob_start();
			?>
            <div id="tb_admin_gs_container" class="wrap">
                <h3 class="page-title"><?php _e( 'Global Styles', 'themify' ); ?></h3>
                <a href="#tb_new_gs_form"
                   class="page-title-action tb_add_new_gs"><?php _e( 'Add new', 'themify' ) ?></a>
                <div class="tb_gs_import_button"><?php echo $button; ?></div>
                <div class="tb_gs_admin_page_header">
                    <div class="tb_gs_post_status">
                        <a <?php echo 'publish' === $page_status ? 'class="tb_gs_active_page"' : ''; ?>
                                href="<?php echo admin_url( 'admin.php?page=themify-global-styles&status=publish' ); ?>"><?php _e( 'Published', 'themify' ); ?></a>
                        <a <?php echo 'trash' === $page_status ? 'class="tb_gs_active_page"' : ''; ?>
                                href="<?php echo admin_url( 'admin.php?page=themify-global-styles&status=trash' ); ?>"><?php _e( 'Trash', 'themify' ); ?></a>
                    </div>
                    <div class="tb_gs_admin_search">
                        <form>
                            <input type="text" name="s">
                            <input type="hidden" name="page" value="themify-global-styles">
                            <input type="hidden" name="status" value="<?php echo $page_status; ?>">
                            <button type="submit"><?php _e( 'Search', 'themify' ); ?></button>
                        </form>
                    </div>
                </div>
				<?php if ( !empty( $_GET['s'] ) ): ?>
                    <h3><?php echo sprintf( __( 'Search Results for ', 'themify' ) . '%s', $_GET['s'] ); ?></h3>
				<?php endif; ?>
                <div class="tb_admin_gs_list" data-list="<?php echo $page_status; ?>">
					<?php if ( !empty( $globalStyles ) ): ?>
						<?php foreach ( $globalStyles as $style ): ?>
                            <div class="tb_gs_element" data-class="<?php echo esc_attr( $style['class'] ); ?>">
                                <div class="tb_gs_thumbnail_container">
                                    <span class="tb_admin_gs_type"><?php echo $style['type']; ?></span>
                                    <a href="#" class="tb_remove_gs ti-close" data-id="<?php echo $style['id']; ?>"></a>
									<?php
									if ( 'publish' === $page_status ): ?>
                                        <a href="<?php echo self::export_url($style['id']); ?>" target="_blank"
                                           class="tb_gs_export ti-export" data-id="<?php echo $style['id']; ?>"></a>
									<?php else: ?>
                                        <a href="#" class="tb_gs_restore ti-back-left"
                                           data-id="<?php echo $style['id']; ?>"></a>
									<?php endif; ?>
                                    <div data-builder="<?php echo esc_url( $style['url'] ); ?>#builder_active"
                                         class="tb_gs_preview_container">
                                        <a href="<?php echo 'publish' === $page_status ? esc_url( $style['url'] ) . '#builder_active' : '#'; ?>"
                                           class="tb_gs_preview_overlay"></a>
										<?php echo $style['preview']; ?>
                                    </div>
                                </div>
                                <span class="tb_admin_gs_title"><?php echo $style['title']; ?></span>
                            </div>
						<?php endforeach; ?>
					<?php else: ?>
                        <p class="wp-heading-inline"><?php _e( 'No Global Styles found.', 'themify' ); ?></p>
					<?php endif; ?>
                </div>
				<?php self::add_new_form(); ?>
				<?php self::pagination(); ?>
            </div>
			<?php
			ob_end_flush();
		}


		/**
		 * Admin page pagination
		 *
		 * @return String
		 */
		static function pagination() {
			$page_num = isset( $_GET['pagenum'] ) ? absint( $_GET['pagenum'] ) : 1;
			$limit = 20;
			$count_posts = wp_count_posts( 'tglobal_style' );
			if ( !isset( $count_posts->publish ) )
				return;
			$total = $count_posts->publish;
			$num_of_pages = ceil( $total / $limit );
			$page_links = paginate_links( array(
				'base' => add_query_arg( 'pagenum', '%#%' ),
				'format' => '',
				'prev_text' => __( '«', 'text-domain' ),
				'next_text' => __( '»', 'text-domain' ),
				'total' => $num_of_pages,
				'current' => $page_num
			) );

			if ( $page_links ) {
				echo '<div class="tablenav"><div class="tablenav-pages">' . $page_links . '</div></div>';
			}
		}

		/**
		 * Create add new Global Style form
		 *
		 * @return String
		 */
		static function add_new_form() {
			$excludes = array( 'page-break', 'divider', 'widget', 'widgetized', 'layout-part', 'plain-text' );
			ob_start();
			?>
            <div id="tb_new_gs_form">
                <div class="tb_gs_form_header">
                    <span class="tb_gs_form_title"><?php _e( 'New Style', 'themify' ); ?></span>
                </div>
                <div class="tb_gs_form_body">
                    <form id="tb_admin_new_gs">
                        <div class="tb_gs_input_container">
                            <label for="style-name"><?php _e( 'Style Name', 'themify' ); ?></label>
                            <input type="text" id="style-name" name="style-name"/>
                        </div>
                        <div class="tb_gs_input_container">
                            <label for="style-type"><?php _e( 'Type', 'themify' ); ?></label>
                            <div class="tb_gs_type_container">
                                <select id="style-type" name="style-type">
                                    <option value="row">Row</option>
                                    <option value="column">Column</option>
									<?php foreach ( Themify_Builder_Model::$modules as $module ): ?>
										<?php if ( in_array( $module->slug, $excludes ) ) continue; ?>
                                        <option value="<?php echo esc_attr( $module->slug ); ?>"><?php echo esc_html( $module->name ); ?></option>
									<?php endforeach; ?>
                                </select>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="tb_gs_form_footer">
                    <a href="#" class="tb_admin_save_gs"><?php _e( 'CREATE', 'themify' ); ?></a>
                </div>
            </div>
			<?php
			return ob_end_flush();
		}

		/**
		 * Get a list of Global Styles
		 *
		 * @param array $args arguments of get posts
		 * @return array
		 */
		static function get_global_styles( $args ) {
			$limit = empty( $args['limit'] ) ? 10 : $args['limit'];
			$paged = empty( $args['paged'] ) ? '' : $args['paged'];
			$data = empty( $args['data'] ) ? false : $args['data'];
			$exclude = empty( $args['loaded'] ) ? array() : $args['loaded'];
			$include = empty( $args['include'] ) ? array() : $args['include'];
			$preview = empty( $args['preview'] ) ? false : $args['preview'];
			$post_names = empty( $args['post_names'] ) ? array() : $args['post_names'];
			$status = empty( $args['status'] ) ? 'publish' : $args['status'];
			$globalStyles = array();
			$posts_args = array(
				'post_type' => 'tglobal_style',
				'posts_per_page' => $limit,
				'paged' => $paged,
				'post_status' => $status,
				'orderby' => 'date',
				'order' => 'DESC',
				'exclude' => $exclude,
				'include' => $include,
				'post_name__in' => $post_names
			);
			if ( !empty( $args['search'] ) ) {
				$posts_args['s'] = $args['search'];
			}
			$posts = get_posts( $posts_args );
			if ( $posts ) {
				global $ThemifyBuilder;
				foreach ( $posts as $post ) {
					$post_id = $post->ID;
					$globalStyles[ $post_id ] = array(
						'id' => $post_id,
						'title' => $post->post_title,
						'class' => $post->post_name,
						'type' => get_post_meta( $post_id, 'themify_global_style_type', true ),
						'url' => get_permalink( $post_id )
					);
					if ( $preview ) {
						$globalStyles[ $post_id ]['preview'] = self::get_HTML( $post_id );
					}
					if ( $data ) {
						$globalStyles[ $post_id ]['data'] = $ThemifyBuilder->get_builder_data( $post_id );
					}
				}
				if ( !empty( $post_names ) ) {
					krsort( $globalStyles );
				}
			}
			return $globalStyles;
		}

		/**
		 * Return Global Style post output HTML for preview purpose
		 *
		 * @param integer $post_id
		 * @return String
		 */
		public static function get_HTML( $post_id ) {
			global $post;
			$temp = $post;
		    $post = get_post( $post_id );
			$content = $post->post_content;
			$content = apply_filters( 'the_content', $content );
			$content = preg_replace( '#<script(.*?)>(.*?)</script>#is', '', $content );
			$upload_dir = wp_upload_dir();
			$themify_css_dir = $upload_dir['basedir'] . '/themify-css';
			$filesystem = Themify_Filesystem::get_instance();
			$file = $themify_css_dir . '/themify-builder-' . $post->ID . '-generated.css';
			if ( $css = $filesystem->execute->get_contents( $file ) ) {
				$content = '<style>' . $css . '</style>' . $content;
			}
			$post = $temp;
			return $content;
		}

		/**
		 * Enqueue required styles and scripts for Global Styles page
		 *
		 * @param String $page name of the admin page
		 * @return void
		 */
		static function enqueue_admin_scripts( $page ) {

			if ( false === strpos( $page, "themify-global-styles" ) ) {
				return;
			}
			wp_enqueue_style( 'themify-icons', themify_enque( THEMIFY_URI . '/themify-icons/themify-icons.css' ), array(), THEMIFY_VERSION );
			wp_enqueue_style( 'magnific', themify_enque( THEMIFY_URI . '/css/lightbox.css' ), array(), THEMIFY_VERSION );
			wp_enqueue_script( 'magnific', THEMIFY_URI . '/js/lightbox.min.js', array( 'jquery' ), THEMIFY_VERSION, true );
			wp_enqueue_style( 'themify-global-styles-css', themify_enque( THEMIFY_BUILDER_URI . '/css/themify-global-styles.css' ), false, THEMIFY_VERSION );
			wp_enqueue_style( 'themify-icons', themify_enque( THEMIFY_URI . '/themify-icons/themify-icons.css' ), array(), THEMIFY_VERSION );
			wp_register_script( 'themify-global-styles-js', themify_enque( THEMIFY_BUILDER_URI . '/js/themify-global-styles.js' ), array( 'jquery' ), THEMIFY_VERSION, true );
			wp_localize_script( 'themify-global-styles-js', 'themifyGlobalStylesVars', array(
					'messages' => array(
						'formValid' => esc_html__( 'Please enter a name.', 'themify' ),
						'create' => esc_html__( 'Create', 'themify' ),
						'creating' => esc_html__( 'Creating ...', 'themify' ),
						'deleteConfirm' => esc_html__( 'Once it is deleted, all styling associated with this Global Style will be gone. This can not be undone.', 'themify' ),
						'deleteConfirm2' => esc_html__( 'Remove permanently, Are you sure?', 'themify' )
					),
					'nonce' => wp_create_nonce( 'tb_load_nonce' ),
					'ajaxurl' => admin_url( 'admin-ajax.php' )
				)
			);
			wp_enqueue_script( 'themify-global-styles-js' );
		}

		/**
		 * Localize some required data about global styles into Builder scripts
		 * This function is a filter for a hook
		 *
		 * @param array $vars
		 * @return array
		 */
		static function localize_data( $vars ) {
			// localize current post if post type is global style
			$post_id = Themify_Builder_Model::get_ID();
			if ( self::$globalStyle->post_type_name === get_post_type( $post_id ) ) {
				$vars['globalStyleData'] = array(
					'id' => $post_id,
					'class' => get_post_field( 'post_name', $post_id ),
					'type' => get_post_meta( $post_id, 'themify_global_style_type', true ),
                    'exportURL' => self::export_url($post_id)
				);
			} else {
				// Localize used Global Styles in this post/page
				if ( !is_array( self::$used_styles ) ) {
					self::$used_styles = self::used_global_styles( $post_id );
				}
				$vars['globalStyles'] = self::$used_styles;
			}

			return $vars;
		}

		/**
		 * Get list of used Global Styles in a post
		 *
		 * @param int $post_id
		 * @return array list of global styles
		 */
		static function used_global_styles( $post_id ) {
			$usedGlobalStyles = get_post_meta( $post_id, 'themify_used_global_styles', true );
			$globalStyles = array();
			if ( is_array( $usedGlobalStyles ) && !empty( $usedGlobalStyles ) ) {
				$args = array(
					'limit' => -1,
					'post_names' => $usedGlobalStyles,
					'data' => true,
				);
				$globalStyles = self::get_global_styles( $args );
			}
			return $globalStyles;
		}

		/**
		 * Get list of used Global Styles in a post and extract their styles
		 *
		 * @param int $post_id
		 * @return array list of global styles
		 */
		private static function extract_used_global_styles( $post_id ) {
			if ( !empty( $_POST['batch'] ) && !empty( $_POST['action'] ) && 'tb_render_element' === $_POST['action'] ) {
				self::$used_styles = self::used_in_data( $_POST['batch'] );
			} else if ( !is_array( self::$used_styles ) ) {
				self::$used_styles = self::used_global_styles( $post_id );
			}
			$usedGlobalStyles = self::$used_styles;
			$styles = array();
			if ( !empty( $usedGlobalStyles ) ) {
				foreach ( $usedGlobalStyles as $post ) {
					if ( 'row' === $post['type'] ) {
						$styles[ $post['class'] ] = $post['data'][0]['styling'];
					} else if ( 'column' === $post['type'] ) {
						$styles[ $post['class'] ] = $post['data'][0]['cols'][0]['styling'];
					}
					// Temporary prevent to load unnecessary data
					/* else {
						$styles[$post['class']] = $post['data'][0]['cols'][0]['modules'][0]['mod_settings'];
					}*/
				}
			}
			return $styles;
		}

		/**
		 * Add Global Style Breadcrumb below of the toolbar
		 *
		 * @return String
		 */
		static function breadcrumb() {
			if ( !is_admin() ) {
				$post_id = Themify_Builder_Model::get_ID();
				if ( 'tglobal_style' === get_post_type( $post_id ) ) {
					$title = get_the_title( $post_id );
					$type = get_post_meta( $post_id, 'themify_global_style_type', true );
					ob_start();
					?>
                    <div class="global-styles-breadcrumb">
                        <span class="title"><a
                                    href="<?php echo esc_url( admin_url( 'admin.php?page=themify-global-styles' ) ); ?>"><?php _e( 'STYLES', 'themify' ); ?></a></span>
                        <span class="arrow">></span>
                        <span class="title"><?php echo esc_html( strtoupper( $type ) ); ?></span>
                        <span class="arrow">></span>
                        <span class="title"><?php echo esc_html( $title ); ?></span>
                    </div>
					<?php
					return ob_end_flush();
				}
			}
			return '';
		}

		/**
		 * Add Global Styles field to styling tab of modules (It's hidden with CSS)
		 * It's a filter function
		 *
		 * @param array $styling
		 * @return array
		 */
		static function add_field( $styling ) {
			$field = array(
				'id' => 'global_styles',
				'type' => 'custom_css'
			);
			if ( isset( $styling['type'] ) && 'tabs' === $styling['type'] ) {
				$styling['options'][ key( $styling['options'] ) ]['options'][] = $field;
			} else {
				$styling[] = $field;
			}
			return $styling;
		}

		/**
		 * Save used global styles as post meta or trigger global style update function if post type is GS
		 *
		 * @param Int $post_id
		 * @param string $builder_data
		 */
		static function save_used_global_styles( $builder_data, $post_id ) {
			// Update all linked posts if current post type is Global Style
			if ( 'tglobal_style' === get_post_type( $post_id ) ) {
				self::global_style_updated( $post_id );
			} else {
				$global_styles = self::find_in_text( $builder_data );
				update_post_meta( $post_id, 'themify_used_global_styles', $global_styles );
			}
		}

		/**
		 * find gs classes in builder data
		 *
		 * @param string $builder_data
		 * @return array used gs
		 */
		static function find_in_text( $builder_data ) {
			$global_styles = array();
			$builder_data = stripcslashes( $builder_data );
			preg_match_all( '/"global_styles":"(.*?)"/m', $builder_data, $matches );
			if ( !empty( $matches ) ) {
				$styles = implode( ' ', $matches[1] );
				$styles = explode( ' ', $styles );
				$global_styles = array_unique( $styles );
			}
			return $global_styles;
		}

		/**
		 * Get used global styles by data
		 *
		 * @param string $builder_data
		 * @return array used GS in data
		 */
		static function used_in_data( $builder_data ) {
			$globalStyles = array();
			$global_styles = self::find_in_text( $builder_data );
			if ( !empty( $global_styles ) ) {
				$args = array(
					'limit' => -1,
					'post_names' => $global_styles,
					'data' => true,
				);
				$globalStyles = self::get_global_styles( $args );
			}
			return $globalStyles;
		}

		/**
		 * Add used Global Styles classes to module container
		 * It's a filter function
		 *
		 * @param array $props
		 * @param array $fields_args
		 * @return array
		 */
		static function add_global_style_class( $props, $fields_args ) {
			if ( !empty( $fields_args['global_styles'] ) ) {
				$props['class'] .= ' ' . $fields_args['global_styles'];
			}
			return $props;
		}

		/**
		 * Updates all linked posts to a Global Style that has updated
		 * (Remove generated CSS files)
		 *
		 * @param Int $post_id
		 */
		static function global_style_updated( $post_id ) {
			$posts = self::get_linked_posts( $post_id );
			if ( !empty( $posts ) ) {
				$upload_dir = wp_upload_dir();
				$themify_css_dir = $upload_dir['basedir'] . '/themify-css';
				foreach ( $posts as $linked_post_id ) {
					$file = $themify_css_dir . '/themify-builder-' . $linked_post_id . '-generated.css';
					if ( file_exists( $file ) ) {
						@unlink( $file );
					}
				}
			}
		}

		/**
		 * Handle Ajax request for deleting a Global Style
		 */
		public static function delete_global_style_ajaxify() {
			check_ajax_referer( 'tb_load_nonce', 'nonce' );
			$response = array();
			if ( isset( $_POST['id'] ) ) {
				$force = 'publish' === $_POST['status'] ? false : true;
				$delete_post = self::delete_global_style( $_POST['id'], $force );
				if ( false === $delete_post ) {
					$response['status'] = 'failed';
					$response['msg'] = __( 'Something went wrong', 'themify' );
				} else {
					$response['status'] = 'success';
				}
			}
			wp_send_json( $response );
		}

		/**
		 * Handle Ajax request for restoring a Global Style
		 */
		public static function restore_global_style_ajaxify() {
			check_ajax_referer( 'tb_load_nonce', 'nonce' );
			$response = array();
			if ( isset( $_POST['id'] ) ) {
				$restore_post = self::restore_global_style( $_POST['id'] );
				if ( false === $restore_post || null === $restore_post ) {
					$response['status'] = 'failed';
					$response['msg'] = __( 'Something went wrong', 'themify' );
				} else {
					$response['status'] = 'success';
				}
			}
			wp_send_json( $response );
		}

		/**
		 * Delete a Global Style and update all linked posts to that Global Style
		 * (Remove Global Styles CSS from linked posts)
		 *
		 * @param Int $post_id Global Style post ID
		 * @param bool $force Global Style post ID
		 * @return Bool
		 */
		static public function delete_global_style( $post_id, $force = false ) {
			if ( !$force ) {
				self::global_style_updated( $post_id );
			}
			if ( $force ) {
				return wp_delete_post( $post_id, true );
			} else {
				return wp_trash_post( $post_id );
			}
		}

		/**
		 * Restore a Global Style
		 *
		 * @param Int $post_id Global Style post ID
		 * @return Bool
		 */
		static public function restore_global_style( $post_id ) {
			if ( wp_untrash_post( $post_id ) ) {
				return true;
			} else {
				return false;
			}
		}

		/**
		 * Get list of posts ID as an array, that use a specific Global Style
		 *
		 * @param integer $global_style_id
		 * @return array list of posts ID
		 */
		public static function get_linked_posts( $global_style_id ) {
			$posts = array();
			$class = get_post_field( 'post_name', $global_style_id );
			$args = array(
				'post_type' => themify_post_types(),
				'posts_per_page' => -1,
				'meta_query' => array(
					array(
						'key' => 'themify_used_global_styles',
						'value' => $class,
						'compare' => 'LIKE',
					)
				)
			);
			$query = new WP_Query( $args );
			if ( $query->have_posts() ) {
				while ( $query->have_posts() ) {
					$query->the_post();
					$posts[] = get_the_ID();
				}
			}
			wp_reset_query();
			return $posts;
		}

		/**
		 * Handle Ajax request for import global style posts (Copy & Paste Module)
		 *
		 * @access public
		 */
		public static function import_posts_ajax() {
			if ( isset( $_POST['imgid'] ) ) {
				$imgid = $_POST['imgid'];
				!empty( $_POST['_ajax_nonce'] ) && check_ajax_referer( $imgid . 'themify-plupload' );
				$file = wp_handle_upload( $_FILES[ $imgid . 'async-upload' ], array( 'test_form' => true, 'action' => 'tb_import_gs_posts_ajax' ) );
				if ( !empty( $file['error'] ) ) {
					echo json_encode( $file );
					exit;
				}
				//let's see if it's a text file
				$ext = explode( '/', $file['type'] );
				if ( 'plain' === $ext[1] ) {
					$url = wp_nonce_url( 'edit.php' );
					if ( false === ( $creds = request_filesystem_credentials( $url ) ) ) {
						return true;
					}
					if ( !WP_Filesystem( $creds ) ) {
						request_filesystem_credentials( $url, '', true );
						return true;
					}
					global $wp_filesystem;
					if ( $wp_filesystem->exists( $file['file'] ) ) {
						$data = $wp_filesystem->get_contents( $file['file'] );
						$data = json_decode( $data, true );
						$wp_filesystem->delete( $file['file'] );
					} else {
						$file['error'] = __( 'Data could not be loaded', 'themify' );
					}
				}
			} else {
				check_ajax_referer( 'tb_load_nonce', 'tb_load_nonce' );
				$data = !empty( $_POST['data'] ) ? $_POST['data'] : array();
			}
			$globalStyles = self::builder_import( $data );
			if ( isset( $_POST['imgid'] ) ) {
				$file['type'] = $ext[1];
				echo json_encode( $file );
				exit;
			} else {
				wp_send_json( $globalStyles );
			}
		}

		/**
		 * Import GS attached file after builder export
		 *
		 * @param array $data exported gs attached file data
		 * @return array
		 */
		public static function builder_import( $data ) {
			$data = is_object( $data ) ? json_decode( json_encode( $data ), true ) : $data;
			$used_gs = $exist_posts = array();
			if ( is_array( $data ) && !empty( $data ) ) {
				foreach ( $data as $post ) {
					$post_id = get_page_by_path( $post['class'], OBJECT, 'tglobal_style' );
					if ( is_null( $post_id ) ) {
						$args = array(
							'style-name' => $post['title']
						, 'style-type' => $post['type']
						, 'styles' => $post['data']
						, 'slug' => $post['class']
						);
						if ( $gsPost = self::add_new( $args ) ) {
							$used_gs[ $gsPost['id'] ] = $gsPost;
						}
					} else {
						$exist_posts[] = $post_id->ID;
					}
				}
				if ( !empty( $exist_posts ) ) {
					$args = array(
						'limit' => -1
					, 'data' => true
					, 'include' => $exist_posts,
					);
					$exist_posts = self::get_global_styles( $args );
					if ( !empty( $exist_posts ) ) {
						$used_gs = array_merge( $used_gs, $exist_posts );
					}
				}
			}
			return $used_gs;
		}

		/**
		 * Export GS file
		 *
		 * @return bool
		 */
		public static function export() {

			if ( is_admin() && !empty( $_GET['tb_export_gs'] ) && check_admin_referer( 'tb_export_gs_nonce' ) ) {
				$post = self::get_global_styles( array( 'include' => array( $_GET['id'] ), 'data' => true ) );
				if ( empty( $post ) ) {
					return false;
					exit();
				}
				$post = $post[ $_GET['id'] ];
				unset( $post['id'] );
				unset( $post['url'] );
				$styling = Themify_Builder_Import_Export::prepare_builder_data( $post['data'] );
				$styling = $styling[0];
				if ( $post['type'] === 'row' ) {
					$styling = $styling['styling'];
				} elseif ( $post['type'] === 'column' ) {
					$styling = $styling['cols'][0]['styling'];
				} else {
					$styling = $styling['cols'][0]['modules'][0]['mod_settings'];
				}
				$post['data'] = $styling;
				$gs_data = json_encode( array( $_GET['id'] => $post ) );
				ob_start();
				header( 'Content-Type: application/force-download' );
				header( 'Pragma: public' );
				header( 'Expires: 0' );
				header( 'Cache-Control: must-revalidate, post-check=0, pre-check=0' );
				header( 'Cache-Control: private', false );
				header( 'Content-Disposition: attachment; filename="gs_' . $post['class'] . '_' . date( "Y_m_d" ) . '.txt"' );
				header( 'Content-Transfer-Encoding: binary' );
				ob_clean();
				flush();
				echo $gs_data;
				exit();
			}
		}

		/**
		 * Add used Global Styles and extra classes to (Row/Sub Row/Column/Sub Column) container
		 * It's a filter function
		 *
		 * @param array $props
		 * @param array $fields_args
		 * @param array $gs_styles
		 * @return array
		 */
		static function add_class_to_components( $props, $fields_args, $gs_styles ) {
			if ( empty( $fields_args['global_styles'] ) ) {
				return $props;
			}
			$props['class'] .= ' ' . $fields_args['global_styles'];
			// Attach Background Repeat Class (Parallax or Zoom scrolling class)
			$parallax = false === strpos( $props['class'], 'builder-parallax-scrolling' ) ? 'builder-parallax-scrolling' : false;
			$zoom = false === strpos( $props['class'], 'builder-zoom-scrolling' ) ? 'builder-zoom-scrolling' : false;
			if ( $parallax || $zoom ) {
				$used_gs = explode( ' ', trim( $fields_args['global_styles'] ) );
				foreach ( $used_gs as $slug ) {
					if ( !$parallax && !$zoom ) {
						break;
					}
					$value = !empty( $gs_styles[ $slug ]['background_repeat'] ) ? $gs_styles[ $slug ]['background_repeat'] : false;
					if ( $parallax && $value === $parallax ) {
						$props['class'] .= ' ' . $parallax;
						$parallax = false;
					}
					if ( $zoom && $value === $zoom ) {
						$props['class'] .= ' ' . $zoom;
						$zoom = false;
					}
				}
			}
			return $props;
		}

		// Set Used GS Styles
		public static function set_used_gs(){
			if ( 'tglobal_style' === get_post_type( Themify_Builder_Component_Base::$post_id ) ) {
				return false;
			}
			$post_id = !empty($_GET['tb-preview']) && !empty($_GET['id']) && Themify_Builder_Component_Base::$post_id !== $_GET['id'] ? $_GET['id'] : Themify_Builder_Component_Base::$post_id;
			$usedGS = self::extract_used_global_styles( $post_id );
			Themify_Builder_Component_Base::$used_gs = $usedGS;
		}

		/*
		 * Generate Export URL
		*/
		private static function export_url($post_id){
			$export_url = wp_nonce_url( admin_url( 'admin.php?page=themify-global-styles' ), 'tb_export_gs_nonce' );
			$export_url = add_query_arg( 'tb_export_gs', 'true', $export_url );
			$export_url = add_query_arg( 'id', $post_id, $export_url );
			return html_entity_decode($export_url);
        }
	}
}
