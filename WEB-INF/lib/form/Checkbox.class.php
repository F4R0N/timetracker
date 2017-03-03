<?php
// +----------------------------------------------------------------------+
// | Anuko Time Tracker
// +----------------------------------------------------------------------+
// | Copyright (c) Anuko International Ltd. (https://www.anuko.com)
// +----------------------------------------------------------------------+
// | LIBERAL FREEWARE LICENSE: This source code document may be used
// | by anyone for any purpose, and freely redistributed alone or in
// | combination with other software, provided that the license is obeyed.
// |
// | There are only two ways to violate the license:
// |
// | 1. To redistribute this code in source form, with the copyright
// |    notice or license removed or altered. (Distributing in compiled
// |    forms without embedded copyright notices is permitted).
// |
// | 2. To redistribute modified versions of this code in *any* form
// |    that bears insufficient indications that the modifications are
// |    not the work of the original author(s).
// |
// | This license applies to this document only, not any other software
// | that it may be combined with.
// |
// +----------------------------------------------------------------------+
// | Contributors:
// | https://www.anuko.com/time_tracker/credits.htm
// +----------------------------------------------------------------------+

import('form.FormElement');

class Checkbox extends FormElement {
  var $checked = false;
    var $mOptions	= null;

  function __construct($name, $value = '') {
    $this->class = 'Checkbox';
    $this->name = $name;
    $this->value = $value;
  }

	function setChecked($value) { $this->checked = $value; }
	function isChecked() { return $this->checked; }
	
	function setData($value)	{ $this->mOptions = $value; }
	function getData() { return $this->mOptions; }

  function getHtml() {
    if ($this->id == '') $this->id = $this->name;

    $html = "\n\t<input type=\"checkbox\"";
    $html.= " id=\"$this->id\" name=\"$this->name\"";

    if ($this->checked || (($this->value == $this->mOptions) && ($this->value != null)))
      $html.= " checked=\"true\"";

		if ($this->on_change!="")
		   $html .= " onchange=\"$this->on_change\"";
		   
		if ($this->style!="")
		   $html .= " style=\"$this->style\"";


		   
		if (!$this->isEnabled())
		   $html .= " disabled=\"disabled\"";
		   
		$html .= " value=\"".htmlspecialchars($this->mOptions)."\"";
		
		$html .= "/>\n";   
		
		return $html;
	}
}
