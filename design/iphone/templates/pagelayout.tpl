<!DOCTYPE html>
<html lang="{$site.http_equiv.Content-language|wash}">
<head>
    
    {include uri='design:page_head.tpl'}
    {include uri='design:page_head_style.tpl'}
    {include uri='design:page_head_script.tpl'}

    {ezcss_require( 'iphone.css' )}

	<meta id="viewport" name="viewport" content="width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=0;"/
</head>

{def $pagedesign_class = fetch( 'content', 'class', hash( 'class_id', 'template_look' ) )}
{if $pagedesign_class.object_count|eq( 0 )|not}
    {def $pagedesign = $pagedesign_class.object_list[0]}
{/if}

<body>
    <div id="page">
        <div id="main">
            {* Only show full version link and logo on the frontpage *}
            {if $module_result.path|count|eq(1)}
                <div id="logo">
                        {if $pagedesign.data_map.image.content.is_valid|not()}
                            <h1><a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}">{ezini('SiteSettings','SiteName')}</a></h1>
                        {else}
                            <a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}" class="mobile-logo"></a>
                        {/if}
                </div>
            {else}
                <div id="navigation-buttons" class="float-break">
                    <div class="object-right">
                        <a href={"/"|ezurl}><div id="frontpagebutton" class="blue">Frontpage</div></a>
                    </div>
                    {if is_set( $module_result.node_id )}
                    <div class="object-left">
                        {def $current_node=fetch( 'content', 'node', hash( node_id, $module_result.node_id ))}
                        <a href={$current_node.parent.url_alias|ezurl}><div id="backbutton" class="blue">Back</div></a>
                    </div>
                    {/if}
                </div>
            {/if}
            <div id="nav-menu">
                <p id="nav-menu-handler">{'Navigation'|i18n('design/iphone/pagelayout')}</p>
                <div id="nav-menu-items" style="display: none">
                    {def $root_node = fetch( 'content', 'node', hash( 'node_id', $module_result.content_info.node_id ) )
                         $menu_items = fetch( 'content', 'list', hash( 'parent_node_id', $root_node.node_id,
                                                                       'sort_by', $root_node.sort_array,
                                                                       'class_filter_type', 'include', 
                                                                       'class_filter_array', ezini( 'MenuContentSettings', 'TopIdentifierList', 'menu.ini' ) ) )}
                    {if $menu_items}
                        {foreach $menu_items as $menu_item}
                            <ul>
                                <li><a href="{$menu_item.url_alias|ezurl('no')}" title="{$menu_item.name|wash()}">{$menu_item.name|wash()}</a></li>
                            </ul>
                        {/foreach}
                    {/if}
                    
                    {undef $root_node $menu_items}
                </div>
                <script type="text/javascript">
                {literal}
                    (function() {
                        var handler = document.getElementById( 'nav-menu-handler' );
                        if ( !handler ) {
                            return;
                        }
                        handler.addEventListener( 'click', function() {
                            var node = document.getElementById( 'nav-menu-items' ),
                                duration = 1000, start = null, to;

                            node.style.display = 'block';
                            node.style.height = '0px';
                            to = node.scrollHeight;

                            // slide open from 0 to the full height, quadratic ease out
                            var step = function( now ) {
                                if ( start === null ) {
                                    start = now;
                                }
                                var t = Math.min( 1, ( now - start ) / duration );
                                node.style.height = ( to * ( 1 - ( 1 - t ) * ( 1 - t ) ) ) + 'px';
                                if ( t < 1 ) {
                                    window.requestAnimationFrame( step );
                                } else {
                                    node.classList.add( 'nav-menu-expanded' );
                                }
                            };
                            window.requestAnimationFrame( step );
                        } );
                    })();
                {/literal}
                </script>
            </div>

            {$module_result.content}

        </div>
    
        {include uri='design:page_footer.tpl'}
    
    </div>
    

    {include uri='design:page_footer_script.tpl'}

    
    <!--DEBUG_REPORT-->
</body>