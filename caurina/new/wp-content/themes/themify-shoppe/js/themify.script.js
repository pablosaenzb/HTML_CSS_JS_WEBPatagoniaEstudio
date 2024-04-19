/* Themify Theme Scripts */

// Declar object literals and variables
var FixedHeader = {}, LayoutAndFilter = {};
(function ($) {

// Fixed Header /////////////////////////
    FixedHeader = {
        headerHeight: 0,
        hasHeaderSlider: false,
        headerSlider: false,
        $headerWrap: $( '#headerwrap' ),
        $pageWrap: $( '#pagewrap' ),
        init: function () {
			
            if(Themify.body.hasClass( 'revealing-header' )){
                this.headerRevealing();
            }
            if (Themify.body.hasClass('fixed-header')) {
                this.headerHeight = this.$headerWrap.outerHeight(true);
                this.activate();
                $(window).on('scroll touchstart.touchScroll touchmove.touchScroll', this.activate);
            }
            $(window).on('tfsmartresize', function () {
                FixedHeader.$pageWrap.css('paddingTop', Math.floor(FixedHeader.$headerWrap.outerHeight(true)));
            });
            if ($('#gallery-controller').length > 0) {
                this.hasHeaderSlider = true;
            }
			
            // Sticky header logo customizer
            if(themifyScript.sticky_header) {
                    var img = '<img id="sticky_header_logo" src="' + themifyScript.sticky_header.src + '"';
                            if(themifyScript.sticky_header.imgwidth){
                                    img+=' width="'+themifyScript.sticky_header.imgwidth+'"';
                            }
                            if(themifyScript.sticky_header.imgheight){
                                    img+=' height="'+themifyScript.sticky_header.imgheight+'"';
                            }
                            img+='/>';
                    $('#site-logo a').prepend(img);
            }
        },
        activate: function () {
            if (  $(window).scrollTop() >= FixedHeader.headerHeight) {
                if (!FixedHeader.$headerWrap.hasClass('fixed-header')) {
                    FixedHeader.scrollEnabled();
                }
            } else if (FixedHeader.$headerWrap.hasClass('fixed-header')) {
                FixedHeader.scrollDisabled();
            }
        },
        headerRevealing:function(){
            var  direction = 'down',
                previousY = 0,
                _this = this,
                onScroll = function(){
					if(previousY === this.scrollY){
						return;
					}
                    direction = previousY < this.scrollY ? 'down' : 'up';
                    previousY = this.scrollY;
                    if ( 'up' === direction || 0 === previousY ) {
                            if ( _this.$headerWrap.hasClass( 'hidden' ) ) {
                                _this.$headerWrap.css( 'top', '' ).removeClass( 'hidden' );
                            }
                    } else if (  0 < previousY && !_this.$headerWrap.hasClass( 'hidden' )){
                            _this.$headerWrap.css( 'top', -_this.$headerWrap.outerHeight() ).addClass( 'hidden' );     
                    }  
                };
            $( window ).on( 'scroll touchstart.touchScroll touchmove.touchScroll', onScroll);
            onScroll();
        },
        scrollDisabled: function () {
            var _this = FixedHeader;
            _this.$headerWrap.removeClass('fixed-header');
            $('#header').removeClass('header-on-scroll');
            Themify.body.removeClass('fixed-header-on');
            /**
             * force redraw the header
             * required in order to calculate header height properly after removing fixed-header classes
             */
            _this.$headerWrap.hide();
            _this.$headerWrap[0].offsetHeight;
            _this.$headerWrap.show();

            _this.headerHeight = _this.$headerWrap.outerHeight(true);
            _this.$pageWrap.css('paddingTop', Math.floor( _this.headerHeight ));
        },
        scrollEnabled: function () {
            FixedHeader.$headerWrap.addClass('fixed-header');
            $('#header').addClass('header-on-scroll');
            Themify.body.addClass('fixed-header-on');
        }
    };

// Entry Filter /////////////////////////
    LayoutAndFilter = {
        init: function () {
            var isRtl = !Themify.body.hasClass('rtl');
            $('.masonry').each(function(){
                if(this.classList.contains('loops-wrapper')){
                         if($(this).find('.grid-sizer').length===0){
                                 $(this).prepend('<div class="grid-sizer"></div><div class="gutter-sizer"></div>');
                         }
                        var $item = $(this),
                        itemDisplay = $item.css( 'display' );
                        if( itemDisplay !== 'block' ) {
                                $item.css( 'display', 'block' );
                        }
                        var imgLoad = imagesLoaded( $item ),
                                load = function(){
                                        imgLoad.off( 'always', load );
                                        $item.addClass('masonry-done').isotope({
                                                        masonry: {
                                                                columnWidth: '.grid-sizer',
                                                                gutter: '.gutter-sizer'
                                                },
                                                itemSelector: '.loops-wrapper > .post,.loops-wrapper > .product',
                                                        isOriginLeft: isRtl
                                        });
                                };
                        imgLoad.once( 'always', load );
                    }
            });
        },
        destroy: function (el) {
            el.removeClass('masonry masonry-done');
            if('object' === typeof el.data('isotope')){
                    el.isotope('destroy');
            }
        }
    };


// Infinite Scroll ///////////////////////////////
    function doInfinite($container, selector, wpf) {

		// Get max pages for regular category pages and home
		var scrollMaxPages = parseInt(themifyScript.maxPages);

		// Get max pages for Query Category pages
		if (typeof qp_max_pages !== 'undefined') {
			scrollMaxPages = qp_max_pages;
		}
		
		var options = {
				navSelector: '#load-more a:last', // selector for the paged navigation
				nextSelector: '#load-more a:last', // selector for the NEXT link (to page 2)
				itemSelector: selector, // selector for all items you'll retrieve
				loadingText: '',
				donetext: '',
				loading: {img: false, msg: $('<div class="themify_spinner" id="infscr-loading"></div>')},
				maxPage: scrollMaxPages,
				behavior: 'auto' !== themifyScript.autoInfinite ? 'twitter' : '',
				pathParse: function (path) {
					return path.match(/^(.*?)\b2\b(?!.*\b2\b)(.*?$)/).slice(1);
				},
				bufferPx: 50,
				pixelsFromNavToBottom:  $('#sidebar').length>0 && $(window).width()<680?$('#sidebar').height()+$('#footerwrap').height():$('#footerwrap').height()
			};

		/* themifyScript.maxPages is not defined when using WC addon, unset it so infinitescroll can load the posts */
		if ( scrollMaxPages === 0 ) {
			delete options['maxPage'];
		}
			
		if (wpf) {
			options.path = function () {
					var container = $('.wpf-search-container'),
						$form = $('.wpf_form_' + container.data('slug')),
						scroll = $form.find('input[name="wpf_page"]');

					if ($form.length > 0 && scroll.length > 0) {
						var current = scroll.val() === ''?1:parseInt(scroll.val());
						scroll.val(current+1);
						var data = $form.serializeArray(),
							result = {};
						for (var i in data) {
							if ($.trim(data[i].value)) {
								var name = data[i].name.replace('[]', '');
								
								if (!result[name]) {
									result[name] = data[i].value;
								}
								else {
									result[name] += ',' + data[i].value;
								}
							}
						}

						var loc = document.location.href.split('?');
						return loc[0] + '?' +decodeURIComponent($.param(result));

					}
					return false;
				}
		}
		

		// infinite scroll
		$container.infinitescroll(options, function (newElements, instance, url) {
			// call Isotope for new elements
			var $newElems = $(newElements);

			// Mark new items: remove newItems from already loaded items and add it to loaded items
			$('.newItems').removeClass('newItems');
			$newElems.removeClass('first last').first().addClass('newItems');


			$newElems.hide().imagesLoaded().always(function () {

				$newElems.fadeIn();

				$('.wp-audio-shortcode, .wp-video-shortcode').not('div').each(function () {
					var $self = $(this);
					if ($self.closest('.mejs-audio').length === 0) {
						ThemifyMediaElement.init($self);
					}
				});

				// Apply lightbox/fullscreen gallery to new items
				Themify.InitGallery();
				if ('object' === typeof $container.data('isotope')) {
					$container.isotope('appended', $newElems);
				}

				if ($container.hasClass('auto_tiles') && Themify.body.hasClass('tile_enable')) {
					$container.trigger('infiniteloaded.themify', [$newElems]);
				}

				if (history.pushState && !+themifyScript.infiniteURL) {
					history.pushState(null, null, url);
				}

				$('#infscr-loading').fadeOut('normal');
				if (1 === scrollMaxPages) {
					$('#load-more, #infscr-loading').remove();
				}

				/**
				 * Fires event after the elements and its images are loaded.
				 *
				 * @event infiniteloaded.themify
				 * @param {object} $newElems The elements that were loaded.
				 */

				Themify.body.trigger('infiniteloaded.themify', [$newElems]);

				//	$(window).trigger( 'resize' );
			});
			
			if ( !wpf ) {
				scrollMaxPages = scrollMaxPages - 1;
				if (1 < scrollMaxPages && 'auto' !== themifyScript.autoInfinite) {
					$('.load-more-button').show();
				}
			} 
		});

		// disable auto infinite scroll based on user selection
		if ('auto' === themifyScript.autoInfinite) {
			$('#load-more, #load-more a').hide();
		}
    }


	// Load Isotope
    function loadIsotop(condition, callback) {
		if (condition) {
			if (typeof $.fn.isotope !== 'function') {
				Themify.LoadAsync(themifyScript.theme_url + '/js/jquery.isotope.min.js', function () {
						callback();
					},
					null,
					null,
					function () {
						return ('undefined' !== typeof $.fn.isotope);
					});
			} else {
				callback();
			}
		}
	}

    // Test if this is a touch device /////////
    function is_touch_device() {
        return Themify.body.hasClass('touch');
    }

// DOCUMENT READY /////////////////////////
    $(document).ready(function ($) {

        var $body = Themify.body,
            isInit=Themify.is_builder_active?true:null;
        FixedHeader.init();

        if ( $('.has-mega-sub-menu').length ) {
            Themify.LoadAsync(themifyScript.theme_url + '/themify/megamenu/js/themify.mega-menu.js', null,
            null,
            null,
            function () {
                return ('undefined' !== typeof $.fn.ThemifyMegaMenu);
            });
        }
        /////////////////////////////////////////////
        // Entry Filter Layout
        /////////////////////////////////////////////
		if($('.masonry.loops-wrapper').length>0){
			if($.fn.isotope){
				LayoutAndFilter.init();
			}
			else{
				
				Themify.LoadAsync(themifyScript.theme_url + '/js/jquery.isotope.min.js', function () {
					LayoutAndFilter.init();
				},
				null,
				null,
				function () {
					return ('undefined' !== typeof $.fn.isotope);
				});
			}
		}
        


        ///////////////////////////////////////////
        // Initialize infinite scroll
        ///////////////////////////////////////////
        
		Themify.LoadAsync(themifyScript.theme_url + '/js/jquery.infinitescroll.min.js', function () {
			if ( $( '.infinite.loops-wrapper' ).length ) {
				doInfinite( $( '.infinite.loops-wrapper' ), '.infinite.loops-wrapper .post, .infinite.loops-wrapper .product' );
			}
		}, null, null, function () {
			return ('undefined' !== typeof $.fn.infinitescroll);
		});
		
		$(document).on('wpf_ajax_before_replace', function(){
			if ( 'undefined' !== typeof $.fn.infinitescroll ) {
				$('.infinite.loops-wrapper').infinitescroll('unbind');
			}
		 }).on('wpf_ajax_success', function(){
			 if ( 'undefined' !== typeof $.fn.infinitescroll ) {
				doInfinite($('.infinite.loops-wrapper'), '.infinite.loops-wrapper .post', true);
			}
		 });
		

            function AjaxThemifyTiles() {
                if(isInit===null){
                    isInit=true;
                    $(document).ajaxComplete(function (e, request, settings) {
                        if (settings.type === 'POST' && settings.url.indexOf('wpf_search') != -1) {
                            callThemifyTiles($('.loops-wrapper'));
                        }
                    });
                }
            }
            function callThemifyTiles(el) {
	        var container = $('.auto_tiles',el);
                 if(el && el.hasClass('auto_tiles')){
                    container = container.add(el);
                }
	        if (container.length > 0 && $body.hasClass('tile_enable')) {
                    var ThemifyTiles=function () {
                        if (themifyScript) {
                            var dummy = $('<div class="post-tiled tiled-square-small" style="visibility: hidden !important; opacity: 0;" />').appendTo(container.first()),
                                $gutter = themifyScript.tiledata['padding'],
                                $small = parseFloat(dummy.width());
                            dummy.remove();
                            container.each(function () {
                                var $this = $(this),
                                    imgLoad = imagesLoaded( $this ),
                                    onLoad = function () {
                                        imgLoad.off( 'always', onLoad );
                                         $this.children('.product').addClass('post');
                                        var $post = $this.children('.post');
                                        themifyScript.tiledata['padding'] = $this.hasClass('no-gutter') ? 0 : $gutter;
                                        $this.themify_tiles(themifyScript.tiledata, $small);
                                        setClasses($post, $small);
                                    };
                                    imgLoad.once( 'always', onLoad);
                            });
                        }
                    };
                    if ('undefined' === typeof Tiles) {
                        Themify.LoadAsync(themifyScript.theme_url + '/js/tiles.min.js',
                                        function () {
                                        if (!$.fn.themify_tiles) {
                                                Themify.LoadAsync(themifyScript.theme_url + '/js/themify-tiles.js', function () {
                                                                ThemifyTiles();
                                                                AjaxThemifyTiles();
                                                        },
                                                        null,
                                                        null,
                                                        function () {
                                                                return ('undefined' !== typeof $.fn.themify_tiles);
                                                        });
                                        }
                                        else {
                                                ThemifyTiles();
                                                AjaxThemifyTiles();
                                        }
                            }, null,
                            null,
                            function () {
                                    return ('undefined' !== typeof Tiles);
                            });
                    }
                    else {
                            ThemifyTiles();
                            AjaxThemifyTiles();
                    }
	        }

            }
            
		
            function ShopdockPlusIconMove(el) {
                // Shopdock Plugin Plus Icon
                if( $('#addon-shopdock').length>0) {
                    var plusicon = $('.overlay.loops-wrapper, .polaroid.loops-wrapper, .auto_tiles.loops-wrapper',el);
                    if(plusicon.length>0) {
                        $('li.product').each(function() {
                            $(this).append( $(this).find('.add_to_cart_button') ); 
                        });
                    }
                }	
            }
            
            var InitBuilderModuleInit = function(el){
                callThemifyTiles(el);
                ShopdockPlusIconMove(el);
            };
            
            if (Themify.is_builder_active) {
                var addWcClass = function(){
                    if (!$body.hasClass('woocommerce') && $('.products.loops-wrapper').length > 0 ) {
                        $body.addClass('woocommerce woocommerce-page');
                    }  
                    InitBuilderModuleInit();
                };
                $body.on('builder_load_module_partial',function(e,el,type){
                    if (el !== undefined ){
                         var wrap=el.find('.builder-posts-wrap,.wc-products,.products.loops-wrapper').first(),
							 isMasonry = wrap.hasClass('masonry');
						if(!wrap.length){
							return;
						}
                            wrap.css('height','').removeClass('loading-finish');
                            LayoutAndFilter.destroy(wrap);
						var classList = wrap[0].classList;
						if ( isMasonry && (classList.contains( 'grid2' ) || classList.contains( 'grid3' ) || classList.contains( 'grid4' )) ) {
							wrap.addClass( 'masonry' );
							loadIsotop( true, function () {
								LayoutAndFilter.init( el );
							}, true );
                          }
                          else if (wrap.hasClass('auto_tiles')) {
                                InitBuilderModuleInit(el);
                          }
                          else if(wrap.data('themify_tiles')){
                                  wrap.data('themify_tiles').destroy();
                          }
                    }
                });
                if(Themify.is_builder_loaded){
                    addWcClass();
                }
                else{
                    window.top.jQuery('body').one('themify_builder_ready', addWcClass);
                }
            }
            else{
                InitBuilderModuleInit();
            }
		

        /////////////////////////////////////////////
        // Search Form							
        /////////////////////////////////////////////
        var $search = $('#search-lightbox-wrap');
        if ($search.length > 0) {
            var cache = [],
                    xhr,
                    $input = $search.find('#searchform input'),
                    $result_wrapper = $search.find('.search-results-wrap');
            $('.search-button, #close-search-box').click(function (e) {
                e.preventDefault();
                if ($input.val().length) {
                    $search.addClass('search-active');
                } else {
                    $search.removeClass('search-active')
                }
                if ($(this).hasClass('search-button')) {
                    $search.fadeIn(function () {
                        $input.focus();
                        $body.css('overflow-y', 'hidden');
                    });
                    $body.addClass('searchform-slidedown');
                }
                else {
                    if (xhr) {
                        xhr.abort();
                    }
                    $search.fadeOut();
                    $body.css('overflow-y', 'visible').removeClass('searchform-slidedown');
                }
            });

            $result_wrapper.delegate('.search-option-tab a', 'click', function (e) {
                e.preventDefault();
                var $href = $(this).attr('href').replace('#', '');
                if ($href === 'all') {
                    $href = 'item';
                }
                else {
                    $result_wrapper.find('.result-item').stop().fadeOut();
                }
                if ($('#result-link-' + $href).length > 0) {
                    $('.view-all-button').hide();
                    $('#result-link-' + $href).show();
                }
                $result_wrapper.find('.result-' + $href).stop().fadeIn();
                $(this).closest('li').addClass('active').siblings('li').removeClass('active');
            });

            $input.prop('autocomplete', 'off').keyup(function (e) {
                if($input.val().length > 0){
                    $search.addClass('search-active');
                }else{
                    $search.removeClass('search-active');
                }
                function set_active_tab(index) {
                    if (index < 0) {
                        index = 0;
                    }
                    $result_wrapper.find('.search-option-tab li').eq(index).children('a').trigger('click');
                    $result_wrapper.show();
                }
                if ((e.keyCode >= 48 && e.keyCode <= 57) || (e.keyCode >= 65 && e.keyCode <= 90) || e.keyCode === 8) {
                    var $v = $.trim($(this).val());
                    if ($v) {
                        if (cache[$v]) {
                            var $tab = $result_wrapper.find('.search-option-tab li.active').index();
                            $result_wrapper.hide().html(cache[$v]);
                            set_active_tab($tab);
                            return;
                        }
                        setTimeout(function () {
                            $v = $.trim($input.val());
                            if (xhr) {
                                xhr.abort();
                            }
                            if (!$v) {
                                $result_wrapper.html('');
                                return;
                            }

                            xhr = $.ajax({
                                url: themifyScript.ajax_url,
                                type: 'POST',
                                data: {'action': 'themify_search_autocomplete', 'term': $v},
                                beforeSend: function () {
                                    $search.addClass('themify-loading');
                                    $result_wrapper.html('<span class="themify_spinner"></span>');
                                },
                                complete: function () {
                                    $search.removeClass('themify-loading');
                                },
                                success: function (resp) {
                                    if (!$v) {
                                        $result_wrapper.html('');
                                    }
                                    else if (resp) {
                                        var $tab = $result_wrapper.find('.search-option-tab li.active').index();
                                        $result_wrapper.hide().html(resp);
                                        set_active_tab($tab);
                                        $result_wrapper.find('.search-option-tab li.active')
                                        cache[$v] = resp;
                                    }
                                }
                            });
                        }, 100);
                    }
                    else {
                        $result_wrapper.html('');
                    }
                }
            });
        }
        /////////////////////////////////////////////
        // Scroll to top 							
        /////////////////////////////////////////////
        $('.back-top a').click(function () {
            $('body,html').animate({
                scrollTop: 0
            }, 800);
            return false;
        });
		
		var $back_top = $('.back-top');
		if($back_top.length>0){
			if($back_top.hasClass('back-top-float')){
				$(window).on("scroll touchstart.touchScroll touchmove.touchScroll", function() {
					if( window.scrollY < 10){
						$back_top.addClass('back-top-hide');
					}else{
						$back_top.removeClass('back-top-hide');
					}
				});

			}
		}

	    function toggleMobileSidebar() {
		    var item = $('.toggle-sticky-sidebar'),
			    sidebar = $("#sidebar");
		    item.on('click', function () {
			    if (item.hasClass('open-toggle-sticky-sidebar')) {
				    item.removeClass('open-toggle-sticky-sidebar').addClass('close-toggle-sticky-sidebar');
				    sidebar.addClass('open-mobile-sticky-sidebar');
			    } else {
				    item.removeClass('close-toggle-sticky-sidebar').addClass('open-toggle-sticky-sidebar');
				    sidebar.removeClass('open-mobile-sticky-sidebar');
			    }
		    });
	    }
	    toggleMobileSidebar();

        /////////////////////////////////////////////
        // Toggle main nav on mobile 							
        /////////////////////////////////////////////

        // Set Slide Menu /////////////////////////
        if ($body.hasClass('header-minbar-left') || $body.hasClass('header-left-pane') || $body.hasClass('header-slide-left')) {
            $('#menu-icon').themifySideMenu({
                close: '#menu-icon-close',
                side: 'left'
            });
        }
        else {
            $('#menu-icon').themifySideMenu({
                close: '#menu-icon-close'
            });
        }
        if ($body.hasClass('no-touch')) {
			if (!$.fn.themifyDropdown) {
			Themify.LoadAsync(themify_vars.url + '/js/themify.dropdown.js', function () {
					$('#main-nav').themifyDropdown();
				},
				null,
				null,
				function () {
					return ('undefined' !== typeof $.fn.themifyDropdown);
				});
			}
			else {
				$('#main-nav').themifyDropdown();
			}
			var $niceScrollTarget = $('.top-icon-wrap #cart-list'),
            $niceScrollMenu = $body.is('.header-minbar-left,.header-minbar-right,.header-overlay,.header-slide-right,.header-slide-left')?
            $('#mobile-menu'):($body.is('.header-left-pane,.header-right-pane')?$('#headerwrap'):false);
			if(($niceScrollMenu && $niceScrollMenu.length>0) || $niceScrollTarget.length>0){
                Themify.LoadAsync(themifyScript.theme_url + '/js/jquery.nicescroll.min.js', function () {
                        if($niceScrollTarget.length>0){
                                $niceScrollTarget.niceScroll();
                                setTimeout(function () {
                                        $niceScrollTarget.getNiceScroll().resize();
                                }, 200);
                         }

                        if($niceScrollMenu){
                                $niceScrollMenu.niceScroll();
                                $body.on('sidemenushow.themify', function () {
                                        setTimeout(function () {
                                                $niceScrollMenu.getNiceScroll().resize();
                                        }, 200);
                                });
                        }
                }, 
                null,
                null,
                function () {
                        return ('undefined' !== typeof $.fn.niceScroll);
                });
            }
        }
        // Set Body Overlay Show/Hide /////////////////////////
        var $overlay = $('<div class="body-overlay">');
        $body.append($overlay).on('sidemenushow.themify', function () {
            $overlay.addClass('body-overlay-on');
        }).on('sidemenuhide.themify', function () {
            $overlay.removeClass('body-overlay-on');
        }).on('click.themify touchend.themify', '.body-overlay', function () {
            $('#menu-icon').themifySideMenu('hide');
            $('.top-icon-wrap #cart-link').themifySideMenu('hide');
        });

        // Set Body Overlay Resize /////////////////////////
        $(window).on('tfsmartresize', function () {
            if ($('#menu-icon').is(':visible') && $('#mobile-menu').hasClass('sidemenu-on')) {
                $overlay.addClass('body-overlay-on');
            }
            else {
                $overlay.removeClass('body-overlay-on');
            }
        });

        // Set Dropdown Arrow /////////////////////////
        if (is_touch_device() && typeof $.fn.themifyDropdown != 'function') {
            Themify.LoadAsync(themify_vars.url + '/js/themify.dropdown.js', function () {
                $('#main-nav').themifyDropdown();
            });
        }
        $("#main-nav li.menu-item-has-children > a, #main-nav li.page_item_has_children > a").after("<span class='child-arrow'></span>");
        $('#main-nav .child-arrow,#main-nav a').click(function(e){
                var toggle = true,
                        item = $(this);
                if(this.tagName==='A'){
                        if(item.attr('href')==='#' && item.next('.child-arrow').length>0){
                                item = item.next('.child-arrow');
                        }
                        else{
                                toggle = false;
                        }
                }
                if(toggle){
                        e.preventDefault();
                        item.toggleClass('toggle-on');
                }
        });
        if ($body.hasClass('header-left-pane') || $body.hasClass('header-right-pane') ) {
			 var $HLicons = $('.top-icon-wrap, .search-button'),
				 $HLiconswrapper = $('#mobile-menu');
			$( $HLiconswrapper ).prepend( $( '<div class="header-icons"></div>' ) );
			$( '.header-icons' ).append( $HLicons );
        }
        if ($body.hasClass('header-overlay')) {
			$('.search-button').appendTo('.top-icon-wrap');
			$('#mobile-menu').wrapInner('<div class="overlay-menu-sticky"></div>' );
		}

		// Mobile cart
		( function( $cart, $mobMenu ) {
			if( $cart.length && $mobMenu.length && ! $body.is( '.header-left-pane, .header-right-pane, .header-minbar-left, .header-minbar-right' ) ) {
				var $cartIcon = $cart.clone(),
					$cartMenu = $( '#shopdock' ),
					$cartMenuClone = $cartMenu.clone(),
					isSlideCart = $( '#slide-cart' ).length,
					id = $cartMenu.attr( 'id' ),
					fakeId = id + '_',
					toggleId = function() {
						if( $cartIcon.is( ':visible' ) ) {
							$cartMenu.attr( 'id', fakeId ).hide();
							$cartMenuClone.attr( 'id', id ).show();
						} else {
							$cartMenu.attr( 'id', id ).show();
							$cartMenuClone.attr( 'id', fakeId ).hide();
						}
					};

				$cartIcon
					.addClass( 'icon-menu' )
					.find( '.tooltip' )
					.remove()
					.end()
					.insertBefore( $mobMenu )
					.wrap( '<div id="cart-link-mobile" />' );

				! isSlideCart && $( '#cart-link-mobile' ).append( $cartMenuClone );

				$cartIcon.on( 'click', function( e ) {

					if ($body.hasClass('cart-style-link_to_cart') )
						return;
					e.preventDefault();
					$cart.is( '#cart-link' ) && $cart.trigger( 'click' );
				} );
				
				if( ! isSlideCart ) {
                                    toggleId();
                                    $( window ).on( 'tfsmartresize', toggleId );
				}
			}

		} )( $( '#cart-icon-count > a' ), $( '#menu-icon' ) );
		
		if ( $body.hasClass( 'header-bottom' ) ) {
			$("#footer").after("<a class='footer-tab' href='#'></a>");
			$(".footer-tab").click(function (e) {
				e.preventDefault();
				$('#footerwrap').toggleClass('expanded');
			});
			$("#footer .back-top").detach().appendTo('#pagewrap');
			$('.back-top').addClass('back-top-float back-top-hide');

			var $back_top = $('.back-top');
			if($back_top.length>0){
				if($back_top.hasClass('back-top-float')){
					$(window).on("scroll touchstart.touchScroll touchmove.touchScroll", function() {
						if( window.scrollY < 10){
							$back_top.addClass('back-top-hide');
						}else{
							$back_top.removeClass('back-top-hide');
						}
					});

				}
			}

		}
		
		/* COMMENT FORM ANIMATION */
		$('input, textarea').focus(function(){
			$(this).parents('#commentform p').addClass('focused');
		}).blur(function(){
			var inputValue = $(this).val();
			if ( inputValue == "" ) {
				$(this).removeClass('filled').parents('#commentform p').removeClass('focused');  
			} else {
				$(this).addClass('filled');
			}
		});
		
		// Top Bar Widget
            $('.top-bar-widgets').clone().insertBefore('#menu-icon-close');
            $(window).on('tfsmartresize', function () {
                            if ( $('.top-bar-widgets').height() > 0 ) {
                                    if ($body.hasClass('header-minbar-left')) {
                                            $('#headerwrap, .search-button, .top-icon-wrap, .logo-wrap').css('left', $('.top-bar-widgets').height());
                                            $('#menu-icon').css('left', $('.top-bar-widgets').height()+( ( $('.logo-wrap').height() - $('#menu-icon').width())/2 ));
                                            $body.css('marginLeft', $('.top-bar-widgets').height());
                                    }
                                    if ($body.hasClass('header-minbar-right')) {
                                            $('#headerwrap, .search-button, .top-icon-wrap').css('right', $('.top-bar-widgets').height());
                                            $('#menu-icon').css('right', $('.top-bar-widgets').height()+( ( $('.logo-wrap').height() - $('#menu-icon').width())/2 ));
                                            $body.css('marginRight', $('.top-bar-widgets').height());
                                    }
                            }
            });

	});

// WINDOW LOAD /////////////////////////
    $(window).load(function () {

        
            // Lightbox / Fullscreen initialization ///////////
            if (typeof ThemifyGallery !== 'undefined') {
                ThemifyGallery.init({'context': $(themifyScript.lightboxContext)});
            }

		///////////////////////////////////////////
		// Header Video
		///////////////////////////////////////////
		var $header = $('#headerwrap'),
			$videos = $header.find('[data-fullwidthvideo]');

		if($header.data('fullwidthvideo')){
			$videos = $videos.add($header);
		}
		function ThemifyBideo(){

			var init = true,
				$fixed = $header.hasClass('fixed-header');

			if ($fixed){
				$header.removeClass('fixed-header');
			}

			$videos.each(function(i){
				var url = $(this).data('fullwidthvideo');
				if(url){
					var options = {
						url: url,
						doLoop: true,
						ambient:true,
						id: i
					};
					if (init && $fixed){
						init = false;
						options['onload'] = function(){
							$header.addClass('fixed-header');
						};
					}
					$(this).ThemifyBgVideo(options);
				}
			});
		}
                if($videos.length>0){
                    if (!is_touch_device()) {
                        if(typeof $.fn.ThemifyBgVideo === 'undefined'){
                                Themify.LoadAsync(
                                        themify_vars.url + '/js/bigvideo.js',
                                        ThemifyBideo,
                                        null,
                                        null,
                                        function () {
                                                return ('undefined' !== typeof $.fn.ThemifyBgVideo);
                                        }
                                );
                        }
                        else{
                                ThemifyBideo();
                        }
                    }
                    else {
                        $videos.each(function (key) {
                                var videoSrc = $(this).data('fullwidthvideo'),
                                        videoEl;

                                if ( videoSrc ) {

                                        if ( videoSrc.indexOf('.mp4') >= 0 && videoSrc.indexOf(window.location.hostname) >= 0 ){

                                                $(this).addClass('themify-responsive-video-background');
                                                videoEl = $('<div class="header-video-wrap">'
                                                        +'<video class="responsive-video header-video video-'+key +'" muted="true" autoplay="true" loop="true" playsinline="true" >' +
                                                        '<source src="' + videoSrc + '" type="video/mp4">' +
                                                        '</video></div>')
                                                videoEl.prependTo($(this));
                                        }
                                }
                        });
                    }
                }

        // EDGE MENU /////////////////////////
        $(function ($) {
            $("#main-nav li").on('mouseenter mouseleave', function (e) {
                if ($('ul', this).length) {
                    var elm = $('ul:first', this) ;
                    if (!(elm.offset().left + elm.width() <=  $(window).width())) {
                        $(this).addClass('edge');
                    } else {
                        $(this).removeClass('edge');
                    }

                }
            });
        });

    }).on("load tfsmartresize", function (e) {
        var viewport = $(window).width(),
                $body = Themify.body;
        if ($body.hasClass('header-logo-center')) {
            if (viewport > 1183) {
                var $HalfWidth = $(window).width() / 2 - $('#site-logo').width() / 2;
                $('#main-nav').css('max-width', $HalfWidth);
            }
            else {
                $('#main-nav').removeAttr('style');
            }
        }
        else if ($body.hasClass('header-slide-right') || $body.hasClass('header-slide-left')) {

            var $swapWrap = $('.top-icon-wrap, .search-button'),
				$sidePanel = $('#mobile-menu'),
				$insertWrapper = $('#main-nav-wrap');

            // Move menu into side panel on small screens /////////////////////////
            if (viewport > tf_mobile_menu_trigger_point) {
                $sidePanel.before($swapWrap);
            } else {
                $insertWrapper.before($swapWrap);
            }

        }

    });

	// Mega menu width
	var MegaMenuWidth = function(){
		
		if ($(window).width() > tf_mobile_menu_trigger_point) { 
			$('#main-nav li.has-mega-column > ul, #main-nav li.has-mega-sub-menu > .mega-sub-menu').css('width',  $('#header').width());
		} else {
			$('#main-nav li.has-mega-column > ul, #main-nav li.has-mega-sub-menu > .mega-sub-menu').removeAttr("style");
		}
	};
	$( document ).on( 'ready',MegaMenuWidth );
	$( window ).on( 'tfsmartresize',MegaMenuWidth );

	// Revealing footer
	var revealingFooter = function() {
		var currentColor, contentParents, isSticky,
			$footer = $( '#footerwrap' ),
			$footerInner = $footer.find( '#footer' ),
			footerHeight = $footer.innerHeight(),
			$content = $( '#body' ),
			resizeCallback = function() {
				footerHeight = $footer.innerHeight();
				! isSticky && $footer.parent().css( 'padding-bottom', footerHeight );
			},
			scrollCallback = function() {
				var contentPosition = $content.get( 0 ).getBoundingClientRect(),
					footerVisibility = window.innerHeight - contentPosition.bottom;

				$footer.toggleClass( 'active-revealing', contentPosition.top < 0 );

				if( footerVisibility >= 0 && footerVisibility <= footerHeight ) {
					$footerInner.css( 'opacity', footerVisibility / footerHeight + 0.2 );
				} else if( footerVisibility > footerHeight ) {
					$footerInner.css( 'opacity', 1 );
				}
			};

		if( ! $footer.length && ! $content.length ) return;

		// Check for content background
		contentParents = $content.parents();

		if( contentParents.length ) {
			 $content.add( contentParents ).each( function() {
				if( ! currentColor ) {
					var elColor = $( this ).css( 'background-color' );
					if( elColor && elColor !== 'transparent' && elColor !== 'rgba(0, 0, 0, 0)' ) {
						currentColor = elColor;
					}
				}
			} );
		}

		$content.css( 'background-color', currentColor || '#ffffff' );

		// Sticky Check
		isSticky = $footer.css( 'position' ) === 'sticky';
		Themify.body.toggleClass( 'no-css-sticky', ! isSticky );

		resizeCallback();
		scrollCallback();
		$( window ).on( 'tfsmartresize', resizeCallback ).on( 'scroll', scrollCallback );
	};

	if( Themify.body.hasClass( 'revealing-footer' ) ) {
		$( document ).on( 'ready', revealingFooter );
	}
	

})(jQuery);
