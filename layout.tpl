{EXPOGROUPITEM:}
	<ol class="breadcrumb">
		<li><a href="/">Главная</a></li>
		<li><a href="/{config.crumb}">{config.title}</a></li>
		<li><a href="/{config.crumb}/{crumb.parent.name}">{crumb.parent.name}</a></li>
		<li class="active">{crumb.name}</li>
		<li><a href="/{config.crumb}/bid">Заявка</a></li>
	</ol>
	<h1>{crumb.name}</h1>
	
	<div class="space expo">
		{data.list[crumb.parent.name]data::finditem}
		<div style="clear:both"></div>
	</div>

	
	<h1>{crumb.parent.name}</h1>
	{data.list[crumb.parent.name]:datatable}
	{finditem:}
		{crumb.name=Артикул?:itembig}
	{itembig:}
		<div class="text-success absblock" style="font-size:130%; margin-top:15px; margin-left:15px">{Артикул}</div>
		<div style="min-height:200px; border:solid 1px #eee;">
			<img class="img-responsive" src="/-imager/?w=500&src={data.folder}{...title}/{Наименование}.jpg&or={data.folder}{...title}/{Артикул}.jpg">
			<div>{Описание}</div>
			<pre class="pull-right"><b>{Артикул}</b>
{Комплектация}<div style="margin-top:10px"><a href="/{config.crumb}/bid" class="btn btn-danger">Оформить сейчас</a></div></pre>
		</div>		
		{:presentcost}
{datatable:}
	<div class="datatable">
		<style scoped>
			.datatable table td {
				vertical-align: top;
				padding:10px;
			}
		</style>
		<table>
			{data::dataitem}
		</table>
	</div>
	{dataitem:}
		{~even()?:tr}<td>{:present}</td>{~odd()?:/tr}
	{/tr:}</tr>
	{tr:}<tr>
{EXPOGROUP:}
	<ol class="breadcrumb">
		<li><a href="/">Главная</a></li>
		<li><a href="/{config.crumb|crumb}">{config.title}</a></li>
		<li class="active">{crumb.name}</li>
		<li><a href="/{config.crumb}/bid">Заявка</a></li>
	</ol>
	<h1>{crumb.name}</h1>
	
	{data.list[crumb.name]:datatable}
	
{EXPOSHORT:}
	<div class="row expo">
		{data.list::shortitem}
	</div>
	{shortitem:}
		<div class="col-sm-6">
			<a style="font-weight: bold; font-size:28px" href="/{config.crumb|crumb}/{title}">{title}</a>
			{data.0:presentGroup}
		</div>
	{present:}
		<a href="/{config.crumb|crumb}/{...title}/{Артикул}" style="margin-bottom: 0; text-align:left; border:solid 1px #eee; display:block;">	
			<div class="text-success absblock" style="margin-left:10px; margin-top:10px;">{Артикул}</div>
			<div style="min-height:50px">
				<img class="img-responsive" src="/-imager/?w=400&src={data.folder}{...title}/{Наименование}.jpg&or={data.folder}{...title}/{Артикул}.jpg">
			</div>
		</a>
		{:presentcost}
	{presentGroup:}
		<a href="/{config.crumb|crumb}/{...title}" style="margin-bottom: 0; text-align:left; border:solid 1px #eee; display:block;">	
			<div class="text-success absblock" style="margin-left:10px; margin-top:10px;">{Артикул}</div>
			<div style="min-height:50px">
				<img class="img-responsive grayscale" src="/-imager/?h=250&src={data.folder}{...title}/{Наименование}.jpg&or={data.folder}{...title}/{Артикул}.jpg">
			</div>
		</a>
		{:presentcost}
	{presentcost:}
		<blockquote style="border-bottom:solid 1px #eee; display:block;border-right:solid 1px #eee; display:block;">
			<div style="float:left">{Акция?:costaction?:costsimple}</div>
			<div style="clear:both"></div>
		</blockquote>
		{costsimple:}
			<div style="font-size:150%;">Цена: <span class="text-success"><b>{~cost(Цена)}</b>&nbsp;руб.</span></div>
			<div style="font-size:100%;">Опт: <b>{~cost(Опт)}</b> руб.</div>
		{costaction:}
			<div style="font-size:150%;">Акция: <span style="font-size:60%" class="text-success"><s><b>{~cost(Цена)}</b>&nbsp;руб.</s></span> <span class="text-danger"><b>{~cost(Акция)}</b>&nbsp;руб.</span></div>
			<div style="font-size:100%;">Опт: <b>{~cost(Опт)}</b> руб.</div>
{EXPO:}
	<ol class="breadcrumb">
		<li><a href="/">Главная</a></li>
		<li class="active">{config.title}</li>
		<li><a href="/{config.crumb}/bid">Заявка</a></li>
	</ol>
	<span class="label label-default pull-right" title="Дата обновления">{~date(:j F Y,data.time)}</span>
	<h1>{config.title}</h1>
	{:optcost}
	{:EXPOSHORT}
{optcost:}
	<div class="well">
		{data.param.descr}
	</div>