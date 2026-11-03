{* Feedback form (contact): what to write about on one side, the form on the other; information collection. *}
{def $fx_dm = $node.data_map}
<div class="fx-container fx-contact">
    <div>
        <p class="fx-kicker">{'Get in touch'|i18n( 'design/ezflow/full/feedback_form' )}</p>
        <h1>{$node.name|wash}</h1>
        {if $fx_dm.description.has_content}<div class="fx-lead">{attribute_view_gui attribute=$fx_dm.description}</div>{/if}
        <ul class="fx-contact__points">
            <li><svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 6h16v12H4z"/><path d="m4 7 8 6 8-6"/></svg><span>{'We answer every message, usually within two working days.'|i18n( 'design/ezflow/full/feedback_form' )}</span></li>
            <li><svg viewBox="0 0 24 24" aria-hidden="true" focusable="false"><path d="M4 19V5h11l5 5v9z"/><path d="M14 5v5h6"/></svg><span>{'Looking for answers right away? Read the %link.'|i18n( 'design/ezflow/full/feedback_form', , hash( '%link', concat( '<a href="https://doc.exponential.earth">', 'documentation'|i18n( 'design/ezflow/full/feedback_form' ), '</a>' ) ) )}</span></li>
        </ul>
    </div>
    <form class="fx-form" method="post" action={"content/action"|ezurl}>
        {include name=Validation uri='design:content/collectedinfo_validation.tpl' class='message-warning' validation=$validation collection_attributes=$collection_attributes}
        <div class="fx-form__grid">
            <label class="fx-field">{$fx_dm.sender_name.contentclass_attribute.name|wash}{attribute_view_gui attribute=$fx_dm.sender_name}</label>
            <label class="fx-field">{$fx_dm.email.contentclass_attribute.name|wash}{attribute_view_gui attribute=$fx_dm.email}</label>
            <label class="fx-field fx-field--wide">{$fx_dm.subject.contentclass_attribute.name|wash}{attribute_view_gui attribute=$fx_dm.subject}</label>
            <label class="fx-field fx-field--wide">{$fx_dm.message.contentclass_attribute.name|wash}{attribute_view_gui attribute=$fx_dm.message}</label>
        </div>
        <input type="hidden" name="ContentNodeID" value="{$node.node_id}">
        <input type="hidden" name="ContentObjectID" value="{$node.object.id}">
        <input type="hidden" name="ViewMode" value="full">
        <div><button class="fx-btn" type="submit" name="ActionCollectInformation" value="1">{'Send message'|i18n( 'design/ezflow/full/feedback_form' )}</button></div>
    </form>
</div>
{undef $fx_dm}
