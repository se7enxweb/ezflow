{* online_users: how many users are signed in; the number refreshes every minute (javascript/ezflow-site.js, through
   ezjscore's ezflow::onlineusers). *}
{def $logged_in_count = fetch( 'user', 'logged_in_count' )}
<section class="fx-block fx-block--compact fx-panel" aria-labelledby="fx-b-{$block.id}" data-fx-online data-fx-url={"ezjscore/call/ezflow::onlineusers"|ezurl}>
    <header class="fx-block__head"><h2 class="fx-block__title" id="fx-b-{$block.id}">{cond( $block.name|trim, $block.name, 'Online users'|i18n( 'design/ezflow/block' ) )|wash}</h2></header>
    <p class="fx-stat"><span data-fx-online-count>{$logged_in_count}</span><small>{'signed-in users right now'|i18n( 'design/ezflow/block' )}</small></p>
</section>
{undef $logged_in_count}
