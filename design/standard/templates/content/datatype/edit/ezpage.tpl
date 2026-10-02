{def $zone_id = ''
     $block_id = ''
     $item_id = ''
     $zone_names = array()
     $zone_layout = cond( $attribute.content.zone_layout, $attribute.content.zone_layout, '' )
     $allowed_zones = fetch('ezflow', 'allowed_zones')
     $can_change_layout = fetch( 'user', 'has_access_to', hash( 'module', 'ezflow', 'function', 'changelayout' ) )
     $current_user = fetch( 'user', 'current_user' )
     $content_object = fetch( 'content', 'object', hash( 'object_id', $attribute.contentobject_id ) )
     $policies = fetch( 'user', 'user_role', hash( 'user_id', $current_user.contentobject_id ) )
     $layout_for_current_class = false()}

     {foreach $policies as $policy}
        {if and( eq( $policy.moduleName, 'ezflow' ),
                    eq( $policy.functionName, 'changelayout' ),
                        is_array( $policy.limitation ) )}
            {if $policy.limitation[0].values_as_array|contains( $content_object.content_class.id )}
                {set $layout_for_current_class = true()}
            {/if}
        {elseif or( and( eq( $policy.moduleName, '*' ),
                             eq( $policy.functionName, '*' ),
                                 eq( $policy.limitation, '*' ) ),
                    and( eq( $policy.moduleName, 'ezflow' ),
                             eq( $policy.functionName, '*' ),
                                 eq( $policy.limitation, '*' ) ),
                    and( eq( $policy.moduleName, 'ezflow' ),
                             eq( $policy.functionName, 'changelayout' ),
                                 eq( $policy.limitation, '*' ) ) )}
            {set $layout_for_current_class = true()}
        {/if}
     {/foreach}

    {if $zone_layout|ne( '' )}
        {set $zone_names = ezini( $zone_layout, 'ZoneName', 'zone.ini' )}
    {/if}

<div id="page-datatype-container" class="ezpage-tabs-skin">
{if and( $can_change_layout, $layout_for_current_class )}
<div class="zones float-break">
{foreach $allowed_zones as $allowed_zone}
{if $allowed_zone['classes']|contains( $attribute.object.content_class.identifier )}
    <div class="zone">
        <div class="zone-label">{$allowed_zone['name']|wash()}</div>
        <div class="zone-thumbnail"><img src={concat( "ezpage/thumbnails/", $allowed_zone['thumbnail'] )|ezimage()} alt="{$allowed_zone['name']|wash()}" /></div>
        <div class="zone-selector">
            <input type="radio" class="zone-type-selector" name="ContentObjectAttribute_ezpage_zone_allowed_type_{$attribute.id}" value="{$allowed_zone['type']}" {if eq( $allowed_zone['type'], $zone_layout )}checked="checked"{/if} />
        </div>
    </div>
{/if}
{/foreach}
    <div class="break"></div>

    <div id="zone-map-container" class="hide float-break">
        <div id="zone-map-type"></div>
        <p>{'The total number of zones in the new layout is less than the number of zones in the previous layout. Therefore, you must map the previous zones to new zones. Unmapped zones will be removed!'|i18n( 'design/standard/datatype/ezpage' )}</p>
        <div id="zone-map-placeholder"></div>
    </div>

    <div class="block">
        <input id="set-zone-layout" class="button" type="submit" name="CustomActionButton[{$attribute.id}_new_zone_layout]" value="{'Set layout'|i18n( 'design/standard/datatype/ezpage' )}" />
    </div>
    <input type="hidden" class="current-zone-count" name="ContentObjectAttribute_ezpage_zone_count_{$attribute.id}" value="{$attribute.content.zones|count()}" />
</div>
{/if}
<div id="zone-tabs-container"></div>
</div>

{ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio', 'ezflowcalendar.js', 'blocktools.js', 'zonetools.js', 'scheduledialog.js' ) )}
{ezcss_require( array( 'ezflowwidgets.css', 'scheduledialog.css', 'ezpage/ezpage.css' ) )}

<script type="text/javascript">
jQuery(function( $ ) {ldelim}
    eZFlow.ZoneLayout.cfg = {ldelim} 'allowedzones': '{$allowed_zones|json()}',
                                     'zonelayout': '{$zone_layout}' {rdelim};
    eZFlow.ZoneLayout.init();

    var tabs = [];

    {foreach $attribute.content.zones as $index => $zone}
        {if and( is_set( $zone.action ), eq( $zone.action, 'remove' ) )}
            {skip}
        {/if}
        tabs.push( {ldelim}
            label: '{$zone_names[$zone.zone_identifier]}',
            dataSrc: '{concat( '/ezflow/zone/', $attribute.id, '/', $attribute.version, '/', $index  )|ezurl(no)}',
            dataLoaded: false
            {rdelim} );
    {/foreach}

    var blockCfg = {ldelim}
        url: "{'ezflow/request'|ezurl('no')}",
        attributeid: {$attribute.id},
        version: {$attribute.version}
    {rdelim};

    {literal}
    // Zone tab view: one tab per zone, its content loaded once from the ezflow/zone view
    var navset = $( '<div class="ezpage-tabs ezpage-tabs-top"><ul class="ezpage-tabs-nav"></ul><div class="ezpage-tabs-content"></div></div>' ),
        nav = navset.children( '.ezpage-tabs-nav' ),
        content = navset.children( '.ezpage-tabs-content' ),
        activeIndex = -1;

    var onDataLoaded = function( tabIndex ) {
        var cfg = $.extend( {}, blockCfg, { zone: tabIndex } );

        eZFlow.BlockDD.cfg = cfg;
        eZFlow.BlockDD.init();
        eZFlow.BlockCollapse.init();
        eZFlow.ScheduleDialog.init();
        BlockDDInit.cfg = cfg;
        BlockDDInit();
    };

    var loadTab = function( tabIndex ) {
        var tab = tabs[tabIndex];

        if ( tab.dataLoaded || tab.loading ) {
            return;
        }
        tab.loading = true;
        content.addClass( 'loading' );
        $.ajax( { type: 'GET', url: tab.dataSrc, dataType: 'html' } )
            .done( function( html ) {
                tab.contentEl.innerHTML = html;
                tab.dataLoaded = true;
                onDataLoaded( tabIndex );
            } )
            .always( function() {
                tab.loading = false;
                content.removeClass( 'loading' );
            } );
    };

    var setActiveIndex = function( tabIndex, fireChange ) {
        if ( tabIndex === activeIndex || !tabs[tabIndex] ) {
            return;
        }
        if ( tabs[activeIndex] ) {
            tabs[activeIndex].li.removeClass( 'selected' ).removeAttr( 'title' );
            $( tabs[activeIndex].contentEl ).addClass( 'ezpage-tabs-hidden' );
        }
        activeIndex = tabIndex;
        tabs[tabIndex].li.addClass( 'selected' ).attr( 'title', 'active' );
        $( tabs[tabIndex].contentEl ).removeClass( 'ezpage-tabs-hidden' );
        loadTab( tabIndex );

        if ( fireChange ) {
            eZFlow.Cookie.set( "eZPageActiveTabIndex", tabIndex, "/" );
            BlockDDInit.cfg.zone = tabIndex;
        }
    };

    $.each( tabs, function( i, tab ) {
        tab.li = $( '<li><a href="#"><em></em></a></li>' );
        tab.li.find( 'em' ).html( tab.label );
        tab.li.children( 'a' ).on( 'click', function( e ) {
            e.preventDefault();
            setActiveIndex( i, true );
        } );
        nav.append( tab.li );
        tab.contentEl = $( '<div class="ezpage-tabs-hidden"></div>' ).appendTo( content )[0];
    } );

    navset.appendTo( '#zone-tabs-container' );

    var activeTabIndex = eZFlow.Cookie.get( 'eZPageActiveTabIndex' );

    if ( activeTabIndex && tabs[ parseInt( activeTabIndex, 10 ) ] ) {
        setActiveIndex( parseInt( activeTabIndex, 10 ), false );
    }
    else {
        setActiveIndex( 0, false );
    }
    {/literal}
{rdelim});

function confirmDiscard( question )
{ldelim}
    // Ask user if he really wants to do it.
    return confirm( question );
{rdelim}
</script>
