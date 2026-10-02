{ezscript_require( array( 'ezjsc::jquery', 'ezjsc::jqueryio' ) )}
<script type="text/javascript">
(function() {ldelim}

jQuery(function($) {ldelim}

        var offset = 0;
        var limit = 3;
        var total = {$block.valid_nodes|count()};

        var handleRequest = function(e) {ldelim}

            var className = e.target.className;
            if ( className == 'carousel-next-button' ) {ldelim}

                offset += 3;

                if ( offset > total )
                    offset = 0;
            {rdelim}

            if ( className == 'carousel-prev-button' ) {ldelim}

                var diff = total - offset;

                if( offset == 0 )
                    offset = Math.floor( total / 3 ) * 3;
                else
                    offset -= 3;
            {rdelim}

            var colContent = $('#block-{$block.id} .col-content');
            colContent.each(function() {ldelim}

                var n = $(this);
                n.addClass('loading');
                var height = this.getBoundingClientRect().bottom - this.getBoundingClientRect().top;
                n.css('height', height + 'px');
                n.html('');
            {rdelim});

            var data = 'http_accept=json&offset=' + offset;
            data += '&limit=' + limit;
            data += '&block_id={$block.id}';

            $.ez( 'ezflow::getvaliditems', data, _callBack );
        {rdelim};

        var _callBack = function(response) {ldelim}

            if ( response !== undefined && response !== null ) {ldelim}

                var colContent = $('#block-{$block.id} .col-content');

                for(var i = 0; i < colContent.length; i++) {ldelim}

                    var colNode = colContent.eq(i);
                    if ( response.content[i] !== undefined )
                        colNode.html( response.content[i] );
                {rdelim}
            {rdelim}
        {rdelim};

            var prevButton = $('#block-{$block.id} input.carousel-prev-button').first();
            prevButton.on('click', handleRequest);

            var nextButton = $('#block-{$block.id} input.carousel-next-button').first();
            nextButton.on('click', handleRequest);

{rdelim});

{rdelim})();
</script>

{def $valid_nodes = $block.valid_nodes}
<!-- BLOCK: START -->
<div id="block-{$block.id}" class="block-type-gallery">

<div class="border-box block-style6-box-outside">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">
<div class="border-content">

<div class="block">
    <div class="left">
        <h2>{$block.name|wash()}</h2>
    </div>
    <div class="right">
        <input type="image" src={"input-img-prev.png"|ezimage()} class="carousel-prev-button" />
        <input type="image" src={"input-img-next.png"|ezimage()} class="carousel-next-button" />
    </div>
    <div class="break"></div>
</div>
<!-- BLOCK BORDER INSIDE: START -->

<div class="border-box block-style6-box-inside">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc">
<div class="border-content">

<!-- BLOCK CONTENT: START -->

<div class="columns-three">
<div class="col-1-2">
<div class="col-1">
<div class="col-content">

{node_view_gui view='block_item' image_class='blockgallery1' content_node=$valid_nodes[0]}

</div>
</div>
<div class="col-2">
<div class="col-content">

{node_view_gui view='block_item' image_class='blockgallery1' content_node=$valid_nodes[1]}

</div>
</div>
</div>
<div class="col-3">
<div class="col-content">

{node_view_gui view='block_item' image_class='blockgallery1' content_node=$valid_nodes[2]}

</div>
</div>
</div>

<!-- BLOCK CONTENT: END -->

</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

<!-- BLOCK BORDER INSIDE: END -->

</div>
</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>

</div>
<!-- BLOCK: END -->

{undef $valid_nodes}