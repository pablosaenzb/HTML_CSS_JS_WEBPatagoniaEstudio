<?php
if (!defined('ABSPATH'))
    exit; // Exit if accessed directly
/**
 * Template Menu
 * 
 * Access original fields: $args['mod_settings']
 * @author Themify
 */
if (TFCache::start_cache($args['mod_name'], self::$post_id, array('ID' => $args['module_ID']))):

    $fields_default = array(
        'mod_title_menu' => '',
        'layout_menu' => '',
        'custom_menu' => 'default',
        'alignment' => 'left',
        'color_menu' => '',
        'according_style_menu' => '',
        'css_menu' => '',
        'animation_effect' => '',
        'menu_breakpoint' => '',
        'menu_slide_direction' => '',
        'mobile_menu_style' => 'slide',
	'allow_menu_fallback' => '',
        'allow_menu_breakpoint' => ''
    );

    if (isset($args['mod_settings']['according_style_menu'])) {
        $args['mod_settings']['according_style_menu'] = self::get_checkbox_data($args['mod_settings']['according_style_menu']);
    }
    $fields_args = wp_parse_args($args['mod_settings'], $fields_default);
    unset($args['mod_settings']);
    $container_class =  apply_filters('themify_builder_module_classes', array(
        'module', 
	'module-' . $args['mod_name'],
	$args['module_ID'],
	$fields_args['css_menu'], 
	self::parse_animation_effect($fields_args['animation_effect'], $fields_args)
                    ), $args['mod_name'], $args['module_ID'], $fields_args);
    if(!empty($args['element_id'])){
	$container_class[] = 'tb_'.$args['element_id'];
    }
    $container_class[] = 'mobile-menu-' . $fields_args['mobile_menu_style'];
    $container_class[] = 'tb-align-' . $fields_args['alignment'];
    $container_props = array('class' => implode(' ', $container_class));
	$container_props['data-menu-style'] = 'mobile-menu-'.$fields_args['mobile_menu_style'];
	if(!empty($fields_args['global_styles'])){
		$container_props['data-gs'] = $fields_args['global_styles'];
    }
    if ($fields_args['allow_menu_breakpoint'] !== '') {
		$container_props['data-menu-breakpoint'] = $fields_args['menu_breakpoint'];
		$container_props['data-menu-direction'] = $fields_args['menu_slide_direction'];
    }
    $container_props['data-element-id'] = !empty($args['element_id']) ? 'tb_'.$args['element_id'] : '';
    $container_props = apply_filters('themify_builder_module_container_props', $container_props, $fields_args, $args['mod_name'], $args['module_ID']);
    $args=null;
    ?>
    <!-- module menu -->
    <div <?php echo self::get_element_attributes(self::sticky_element_props($container_props,$fields_args)); ?>>
	<?php $container_props=$container_class=null; ?>
        <?php if ($fields_args['mod_title_menu'] !== ''): ?>
            <?php echo $fields_args['before_title'] . apply_filters('themify_builder_module_title', $fields_args['mod_title_menu'], $fields_args). $fields_args['after_title']; ?>
        <?php endif; ?>

        <?php if ($fields_args['custom_menu'] !== '' && ! empty(wp_get_nav_menus(array('number'=>1,'orderby'=>'id','update_term_meta_cache'=>false,'pad_counts'=>false)))) {
			$args = array(
			    'menu' => $fields_args['custom_menu'],
			    'menu_class' => 'ui nav ' . $fields_args['layout_menu'] . ' ' . $fields_args['color_menu'] . ' ' . $fields_args['according_style_menu'],
			    'container_class' => 'module-menu-container tb-align-' . $fields_args['alignment']
			);
			wp_nav_menu( $args );
        } elseif ( ! empty( $fields_args['allow_menu_fallback'] ) ) {
			$args = array(
				'title_li'	=> '',
				'echo'		=> 0,
			);
			printf('<ul class="%1$s">%2$s</ul>'
				, 'ui nav ' . $fields_args['layout_menu'] . ' ' . $fields_args['color_menu'] . ' ' . $fields_args['according_style_menu']
				, wp_list_pages( $args ) );
		} ?>
    </div>
    <!-- /module menu -->
<?php endif; ?>
<?php TFCache::end_cache(); ?>
