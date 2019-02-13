<script>
  function chLocation(newLocation) { document.location = newLocation; }
</script>

{$forms.reportForm.open}
<table width="720">
  <td valign="top">
    <table border="0" cellpadding="3" cellspacing="1" width="100%">
      <tr>
        <td valign="top" class="sectionHeaderNoBorder" align="center">{$i18n.form.report.export} {if file_exists('WEB-INF/lib/tcpdf')}<a href="topdf.php">PDF</a>,{/if} <a href="tofile.php?type=xml">XML</a> {$i18n.label.or} <a href="tofile.php?type=csv">CSV</a></td>
      </tr>
    </table>
    <table border="0" cellpadding="3" cellspacing="1" width="100%">
<!-- totals only report -->
{if $bean->getAttribute('chtotalsonly')}
      <tr>
        <td class="tableHeader">{$group_by_header|escape}</td>
        {if $bean->getAttribute('chduration')}<td class="tableHeaderCentered" width="5%">{$i18n.label.duration}</td>{/if}
        {if $bean->getAttribute('chunits')}<td class="tableHeaderCentered" width="5%">{$i18n.label.work_units_short}</td>{/if}
        {if $bean->getAttribute('chcost')}<td class="tableHeaderCentered" width="5%">{$i18n.label.cost}</td>{/if}
      </tr>
  {foreach $subtotals as $subtotal}
      <tr class="rowReportSubtotal">
        <td class="cellLeftAlignedSubtotal">{if $subtotal['name']}{$subtotal['name']|escape}{else}&nbsp;{/if}</td>
        {if $bean->getAttribute('chduration')}<td class="cellRightAlignedSubtotal">{$subtotal['time']}</td>{/if}
        {if $bean->getAttribute('chunits')}<td class="cellRightAlignedSubtotal">{$subtotal['units']}</td>{/if}
        {if $bean->getAttribute('chcost')}<td class="cellRightAlignedSubtotal">{if $user->can('manage_invoices') || $user->isClient()}{$subtotal['cost']}{else}{$subtotal['expenses']}{/if}</td>{/if}
      </tr>
  {/foreach}
      <!-- print totals -->
      <tr><td>&nbsp;</td></tr>
      <tr class="rowReportSubtotal">
        <td class="cellLeftAlignedSubtotal">{$i18n.label.total}</td>
        {if $bean->getAttribute('chduration')}<td nowrap class="cellRightAlignedSubtotal">{$totals['time']}</td>{/if}
        {if $bean->getAttribute('chunits')}<td nowrap class="cellRightAlignedSubtotal">{$totals['units']}</td>{/if}
        {if $bean->getAttribute('chcost')}<td nowrap class="cellRightAlignedSubtotal">{$user->currency|escape} {if $user->can('manage_invoices') || $user->isClient()}{$totals['cost']}{else}{$totals['expenses']}{/if}</td>{/if}
      </tr>
{else}
<!-- normal report -->
      <tr>
        <td class="tableHeader">{$i18n.label.date}</td>
  {if $user->can('view_reports') || $user->can('view_all_reports') || $user->isClient()}<td class="tableHeader">{$i18n.label.user}</td>{/if}
  {if $bean->getAttribute('chclient')}<td class="tableHeader">{$i18n.label.client}</td>{/if}
  {if $bean->getAttribute('chclientnumber')}<td class="tableHeader">{$i18n.label.client_number}</td>{/if}
  {if $bean->getAttribute('chproject')}<td class="tableHeader">{$i18n.label.project}</td>{/if}
  {if $bean->getAttribute('chtask')}<td class="tableHeader">{$i18n.label.task}</td>{/if}
  {if $bean->getAttribute('chcf_1')}<td class="tableHeader">{$custom_fields->fields[0]['label']|escape}</td>{/if}
  {if $bean->getAttribute('chstart')}<td class="tableHeaderCentered" width="5%">{$i18n.label.start}</td>{/if}
  {if $bean->getAttribute('chfinish')}<td class="tableHeaderCentered" width="5%">{$i18n.label.finish}</td>{/if}
  {if $bean->getAttribute('chduration')}<td class="tableHeaderCentered" width="5%">{$i18n.label.duration}</td>{/if}
  {if $bean->getAttribute('chunits')}<td class="tableHeaderCentered" width="5%">{$i18n.label.work_units_short}</td>{/if}
  {if $bean->getAttribute('chnote')}<td class="tableHeader">{$i18n.label.note}</td>{/if}
  {if $bean->getAttribute('chcost')}<td class="tableHeaderCentered" width="5%">{$i18n.label.cost}</td>{/if}
  {if $bean->getAttribute('chpaid')}<td class="tableHeader">{$i18n.label.paid}</td>{/if}
  {if $bean->getAttribute('chip')}<td class="tableHeaderCentered">{$i18n.label.ip}</td>{/if}
  {if $bean->getAttribute('chinvoice')}<td class="tableHeader">{$i18n.label.invoice}</td>{/if}
  {if $bean->getAttribute('chbillable')}<td class="tableHeader">{$i18n.label.billable}</td>{/if}
      </tr>
  {foreach $report_items as $item}
    <!-- print subtotal for a block of grouped values -->
    {$cur_date = $item.date}
    {if $print_subtotals}
      {$cur_grouped_by = $item.grouped_by}
      {if $cur_grouped_by != $prev_grouped_by && !$first_pass}
      <tr class="rowReportSubtotal">
        <td class="cellLeftAlignedSubtotal">{$i18n.label.subtotal}
        {if $user->can('view_reports') || $user->can('view_all_reports') || $user->isClient()}<td class="cellLeftAlignedSubtotal">{$subtotals[$prev_grouped_by]['user']|escape}</td>{/if}
        {if $bean->getAttribute('chclient')}<td class="cellLeftAlignedSubtotal">{$subtotals[$prev_grouped_by]['client']|escape}</td>{/if}
		{if $bean->getAttribute('chclientnumber')}<td></td>{/if}
        {if $bean->getAttribute('chproject')}<td class="cellLeftAlignedSubtotal">{$subtotals[$prev_grouped_by]['project']|escape}</td>{/if}
        {if $bean->getAttribute('chtask')}<td class="cellLeftAlignedSubtotal">{$subtotals[$prev_grouped_by]['task']|escape}</td>{/if}
        {if $bean->getAttribute('chcf_1')}<td class="cellLeftAlignedSubtotal">{$subtotals[$prev_grouped_by]['cf_1']|escape}</td>{/if}
        {if $bean->getAttribute('chstart')}<td></td>{/if}
        {if $bean->getAttribute('chfinish')}<td></td>{/if}
        {if $bean->getAttribute('chduration')}<td class="cellRightAlignedSubtotal">{$subtotals[$prev_grouped_by]['time']}</td>{/if}
        {if $bean->getAttribute('chunits')}<td class="cellRightAlignedSubtotal">{$subtotals[$prev_grouped_by]['units']}</td>{/if}
        {if $bean->getAttribute('chnote')}<td></td>{/if}
        {if $bean->getAttribute('chcost')}<td class="cellRightAlignedSubtotal">{if $user->can('manage_invoices') || $user->isClient()}{$subtotals[$prev_grouped_by]['cost']}{else}{$subtotals[$prev_grouped_by]['expenses']}{/if}</td>{/if}
        {if $bean->getAttribute('chpaid')}<td></td>{/if}
        {if $bean->getAttribute('chip')}<td></td>{/if}
        {if $bean->getAttribute('chinvoice')}<td></td>{/if}
        {if $bean->getAttribute('chbillable')}<td></td>{/if}
        {if $use_checkboxes}<td></td>{/if}
      </tr>
      <tr><td>&nbsp;</td></tr>
      {/if}
    {$first_pass = false}
    {/if}
      <!--  print regular row --> 
      {if $cur_date != $prev_date}
        {if $report_row_class == 'rowReportItem'} {$report_row_class = 'rowReportItemAlt'} {else} {$report_row_class = 'rowReportItem'} {/if}
      {/if}
      <tr class="{$report_row_class}">
        <td class="cellLeftAligned"><a href="time_edit.php?id={$item.id}{if $user->can('manage_users')}&user_id={$item.user_id}{/if}&source=report" title="Edit">{$item.date}</a></td>
    {if $user->can('view_reports') || $user->can('view_all_reports') || $user->isClient()}<td class="cellLeftAligned">{$item.user|escape}</td>{/if}
    {if $bean->getAttribute('chclient')}<td class="cellLeftAligned">{$item.client|escape}</td>{/if}
    {if $bean->getAttribute('chclientnumber')}<td class="cellLeftAligned">{$item.client_number|escape}</td>{/if}
    {if $bean->getAttribute('chproject')}<td class="cellLeftAligned">{$item.project|escape}</td>{/if}
    {if $bean->getAttribute('chtask')}<td class="cellLeftAligned">{$item.task|escape}</td>{/if}
    {if $bean->getAttribute('chcf_1')}<td class="cellLeftAligned">{$item.cf_1|escape}</td>{/if}
    {if $bean->getAttribute('chstart')}<td nowrap class="cellRightAligned">{$item.start}</td>{/if}
    {if $bean->getAttribute('chfinish')}<td nowrap class="cellRightAligned">{$item.finish}</td>{/if}
    {if $bean->getAttribute('chduration')}<td class="cellRightAligned">{$item.duration}</td>{/if}
    {if $bean->getAttribute('chunits')}<td class="cellRightAligned">{$item.units}</td>{/if}
    {if $bean->getAttribute('chnote')}<td class="cellLeftAligned">{$item.note|escape}</td>{/if}
    {if $bean->getAttribute('chcost')}<td class="cellRightAligned">{if $user->can('manage_invoices') || $user->isClient()}{$item.cost}{else}{$item.expense}{/if}</td>{/if}
    {if $bean->getAttribute('chpaid')}<td class="cellRightAligned">{if $item.paid == 1}{$i18n.label.yes}{else}{$i18n.label.no}{/if}{/if}
    {if $bean->getAttribute('chip')}<td class="cellRightAligned">{if $item.modified}{$item.modified_ip} {$item.modified}{else}{$item.created_ip} {$item.created}{/if}{/if}
    {if $bean->getAttribute('chinvoice')}<td class="cellRightAligned">{$item.invoice|escape}</td>{/if}
	{if $bean->getAttribute('chbillable')}<td class="cellLeftAligned">{$item.billable}</td>{/if}
    {if $use_checkboxes}
      {if 1 == $item.type}<td bgcolor="white"><input type="checkbox" name="log_id_{$item.id}"></td>{/if}
      {if 2 == $item.type}<td bgcolor="white"><input type="checkbox" name="item_id_{$item.id}"></td>{/if}
    {/if}
      </tr>
    {$prev_date = $item.date}
    {if $print_subtotals} {$prev_grouped_by = $item.grouped_by} {/if}
  {/foreach}
  <!-- print a terminating subtotal -->
  {if $print_subtotals}
      <tr class="rowReportSubtotal">
        <td class="cellLeftAlignedSubtotal">{$i18n.label.subtotal}
    {if $user->can('view_reports') || $user->can('view_all_reports') || $user->isClient()}<td class="cellLeftAlignedSubtotal">{$subtotals[$cur_grouped_by]['user']|escape}</td>{/if}
    {if $bean->getAttribute('chclient')}<td class="cellLeftAlignedSubtotal">{$subtotals[$cur_grouped_by]['client']|escape}</td>{/if}
	{if $bean->getAttribute('chclientnumber')}<td></td>{/if}
    {if $bean->getAttribute('chproject')}<td class="cellLeftAlignedSubtotal">{$subtotals[$cur_grouped_by]['project']|escape}</td>{/if}
    {if $bean->getAttribute('chtask')}<td class="cellLeftAlignedSubtotal">{$subtotals[$cur_grouped_by]['task']|escape}</td>{/if}
    {if $bean->getAttribute('chcf_1')}<td class="cellLeftAlignedSubtotal">{$subtotals[$cur_grouped_by]['cf_1']|escape}</td>{/if}
    {if $bean->getAttribute('chstart')}<td></td>{/if}
    {if $bean->getAttribute('chfinish')}<td></td>{/if}
    {if $bean->getAttribute('chduration')}<td class="cellRightAlignedSubtotal">{$subtotals[$cur_grouped_by]['time']}</td>{/if}
    {if $bean->getAttribute('chunits')}<td class="cellRightAlignedSubtotal">{$subtotals[$cur_grouped_by]['units']}</td>{/if}
    {if $bean->getAttribute('chnote')}<td></td>{/if}
    {if $bean->getAttribute('chcost')}<td class="cellRightAlignedSubtotal">{if $user->can('manage_invoices') || $user->isClient()}{$subtotals[$cur_grouped_by]['cost']}{else}{$subtotals[$cur_grouped_by]['expenses']}{/if}</td>{/if}
    {if $bean->getAttribute('chpaid')}<td></td>{/if}
    {if $bean->getAttribute('chip')}<td></td>{/if}
    {if $bean->getAttribute('chinvoice')}<td></td>{/if}
    {if $bean->getAttribute('chbillable')}<td></td>{/if}
    {if $use_checkboxes}<td></td>{/if}
      </tr>
  {/if}
  <!-- print totals -->
      <tr><td>&nbsp;</td></tr>
      <tr class="rowReportSubtotal">
        <td class="cellLeftAlignedSubtotal">{$i18n.label.total}</td>
    {if $user->can('view_reports') || $user->can('view_all_reports') || $user->isClient()}<td></td>{/if}
    {if $bean->getAttribute('chclient')}<td></td>{/if}
    {if $bean->getAttribute('chclientnumber')}<td></td>{/if}
    {if $bean->getAttribute('chproject')}<td></td>{/if}
    {if $bean->getAttribute('chtask')}<td></td>{/if}
    {if $bean->getAttribute('chcf_1')}<td></td>{/if}
    {if $bean->getAttribute('chstart')}<td></td>{/if}
    {if $bean->getAttribute('chfinish')}<td></td>{/if}
    {if $bean->getAttribute('chduration')}<td class="cellRightAlignedSubtotal">{$totals['time']}</td>{/if}
    {if $bean->getAttribute('chunits')}<td class="cellRightAlignedSubtotal">{$totals['units']}</td>{/if}
    {if $bean->getAttribute('chnote')}<td></td>{/if}
    {if $bean->getAttribute('chcost')}<td nowrap class="cellRightAlignedSubtotal">{$user->currency|escape} {if $user->can('manage_invoices') || $user->isClient()}{$totals['cost']}{else}{$totals['expenses']}{/if}</td>{/if}
    {if $bean->getAttribute('chpaid')}<td></td>{/if}
    {if $bean->getAttribute('chip')}<td></td>{/if}
    {if $bean->getAttribute('chinvoice')}<td></td>{/if}
    {if $bean->getAttribute('chbillable')}<td></td>{/if}
    {if $use_checkboxes}<td></td>{/if}
      </tr>
{/if}
    </table>
  </td>
</tr>
</table>
{if $report_items && ($use_mark_paid || $use_assign_to_invoice)}
<table width="720" cellspacing="0" cellpadding="0" border="0">
  {if $use_mark_paid}
  <tr>
    <td align="right">
      <table>
        <tr><td>{$i18n.label.mark_paid}: {$forms.reportForm.mark_paid_select_options.control} {$forms.reportForm.mark_paid_action_options.control} {$forms.reportForm.btn_mark_paid.control}</td></tr>
      </table>
    </td>
  </tr>
  {/if}
  {if $use_assign_to_invoice}
  <tr>
    <td align="right">
      <table>
        <tr><td>{$i18n.form.report.assign_to_invoice}: {$forms.reportForm.assign_invoice_select_options.control} {$forms.reportForm.recent_invoice.control} {$forms.reportForm.btn_assign.control}</td></tr>
      </table>
    </td>
  </tr>
  {/if}
</table>
{/if}
{$forms.reportForm.close}

<table width="720" cellspacing="4" cellpadding="4" border="0">
<tr>
  <td align="center">
  <table>
  <tr>
    <td><input type="button" onclick="chLocation('report_send.php');" value="{$i18n.button.send_by_email}"></td>
  </tr>
  </table>
  </td>
</tr>
</table>
