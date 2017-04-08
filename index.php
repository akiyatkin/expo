<?php
use infrajs\load\Load;
use infrajs\excel\Xlsx;
use infrajs\ans\Ans;
use infrajs\path\Path;

$src = Ans::GET('src');
$param = Ans::GET('param');


$fdata = Load::srcinfo($src);
if (!$param) $param = Load::loadJSON($fdata['folder'].$fdata['name'].'.json');
else $param = Load::loadJSON($param);

$folder = $fdata['folder'].$fdata['name'].'/';

$data = Load::loadJSON('-excel/?src='.$src);
Xlsx::runGroups($data, function &(&$group) {
	$r = null;
	$group['id'] = Path::encode($group['title']);
	return $r;
});
Xlsx::runPoss($data, function &(&$pos) {
	$r = null;
	if (!empty($pos['Артикул'])) return $r;
	if (empty($pos['Наименование'])) return $r;
	$pos['Артикул'] = $pos['Наименование'];
	return $r;
});

$list = array();
for ($i = 0; $i < sizeof($data['childs']); $i++) {
	$list[$data['childs'][$i]['title']] = $data['childs'][$i];
}
$ans = array('list' => $list, 'param' => $param, 'folder'=>$folder, 'time' => filemtime(Path::theme($src)));
return Ans::ret($ans);