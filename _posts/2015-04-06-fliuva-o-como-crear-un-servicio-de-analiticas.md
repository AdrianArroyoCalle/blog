---
layout: post
title: Fliuva, o como crear un servicio de analíticas
description: Tutorial de creación de un servicio de analíticas
keywords:
 - analiticas
 - estadistica
 - blogstack
 - programacion
 - tutorial
 - javascript
 - node.js
 - express
---

MODIFICAR CODE PARA HIGHLIGHT

Ya hemos visto los [motivos]({% post_url 2015-04-05-la-informacion-es-poder %}) que tengo para diseñar un servicio de analíticas desde 0. Ahora veremos como lo he hecho.

![Fliuva]({{ site.baseurl }}images/Fliuva.png)

No he tocado ningún CSS.

## La base de datos

En un servicio de analíticas lo más importante son los datos, así que debemos de definir como almacenaremos la información. En principio Fliuva iba a estar centrado en analizar una única aplicación. Más tarde he pensado en un soporte multiaplicaciones pero no lo voy a desarrollar de momento. Usaría un espacio de nombres delante de todas las tablas y las peticiones GET.

> Usuarios = Sesiones

En ciertos servicios de analíticas los usuarios y las sesiones son dos conceptos diferentes. En Fliuva sin embargo, y por razones de simplificar la estructura, ambos conceptos son idénticos y hablaremos de ellos como sesiones.

### Tablas

Será necesario tener una tabla de eventos.

#### EVENTS

|CATEGORY|SUBCATEGORY|NAME|DESCRIPTION|DATA|ID|TIME|SESSION|
|--------|-----------|----|-----------|----|--|----|-------|
|Categoría del evento|Subcategoría del evento|Nombre del evento|Descripción del evento|Datos del evento|Identificador|Hora en que se produjo|Sesión a la que pertenece el evento|

{% highlight sql %}
CREATE TABLE IF NOT EXISTS EVENTS(ID INT NOT NULL AUTO_INCREMENT, CATEGORY TEXT, SUBCATEGORY TEXT, NAME TEXT, DESCRIPTION TEXT, DATA TEXT, TIME DATETIME, SESSION TEXT, PRIMARY KEY (`ID`) )
{% endhighlight  %}

Y ya con esta tabla tendremos para almacenar muchos datos. Los campos CATEGORY, SUBCATEGORY, NAME, DESCRIPTION y DATA sirven unicamente para organizar eventos y subeventos en categorías. Los nombres de los campos son triviales. DESCRIPTION no guarda realmente la descripción sino que podemos definir otro subevento. Con 5 campos para categorizar eventos superamos a Google Analytics que tiene CATEGORY, ACTION, LABEL y VALUE. Además VALUE debe ser numérico mientras que en Fliuva todos son de tipo texto (en la práctica, cualquier cosa).

### Código de seguimiento

¿Cómo introducir datos en la base de datos desde nuestra aplicación? Con una pequeña llamada GET a /collect. Yo la he definido en un fichero llamado collect.js

{% highlight js %}

var mysql=require("mysql");

// GET /collect

module.exports=function(req,res){
	var connection=mysql.createConnection({
		host: process.env.OPENSHIFT_MYSQL_DB_HOST,
		port: process.env.OPENSHIFT_MYSQL_DB_PORT,
		user: process.env.OPENSHIFT_MYSQL_DB_USER,
		password: process.env.OPENSHIFT_MYSQL_DB_PASSWORD,
		database: "fliuva"
	});
	connection.connect(function(err){
		if(err){
			res.send(501,"MySQL connection error\n"+err);
		}
		connection.query("CREATE TABLE IF NOT EXISTS EVENTS(ID INT NOT NULL AUTO_INCREMENT,"+
		"CATEGORY TEXT, SUBCATEGORY TEXT, NAME TEXT, DESCRIPTION TEXT, DATA TEXT, "+
		"TIME DATETIME, SESSION TEXT,"+
		"PRIMARY KEY (`ID`) )",function(err,results,fields){
			if(err){
				res.send(501,"MySQL table creation error\n"+err);
			}
			connection.query("INSERT INTO EVENTS SET ?",{
				SESSION: req.query.SESSION,
				TIME: new Date(),
				CATEGORY: req.query.CATEGORY || "",
				SUBCATEGORY: req.query.SUBCATEGORY || "",
				NAME: req.query.NAME || "",
				DESCRIPTION: req.query.DESCRIPTION || "",
				DATA: req.query.DATA || ""
			},function(err,results,fields){
				if(err){
					res.send(501,"Query error\n"+err);
				}
				res.send("OK");
			});
		});
	});
}

{% endhighlight  %}

Y se llama muy fácilmente

```
GET /collect?CATEGORY=<category>&SUBCATEGORY=<subcategory>&NAME=<name>&DESCRIPTION=<description>&DATA=<data>&SESSION=<session>
```

Si estamos en HTML5, necesitaremos una librería de cliente para poder realizar las llamadas

{% highlight js %}
function login(){
	var xhr=new XMLHttpRequest();
	xhr.open("GET","/uuid");
	xhr.addEventListener("load",function(){
		sessionStorage.__fliuvaSession=xhr.responseText;
	});
	xhr.send();
}

function sendEvent(category,subcategory,name,description,data){
	var xhr=new XMLHttpRequest();
	var url="/collect"+
	"?CATEGORY="+category+
	"&SUBCATEGORY="+subcategory+
	"&NAME"+name+
	"&DESCRIPTION"+description+
	"&DATA"+data+
	"&SESSION"+sessionStorage.__fliuvaSession;
	xhr.open("GET",url);
	xhr.send();
}
{% endhighlight  %}

Así, simplemente hay que llamar a sendEvent. Llamar a `login` no es necesario siempre que rellenes el valor de `sessionStorage.__fliuvaSession` correctamente.

## Análisis de datos

Ahora debemos analizar los datos. Primero debemos obtener los valores a analizar. La llamada a /get devuelve un fichero JSON con la información completa. En un futuro lo ideal sería espeficicar intervalos de fechas.

{% highlight js %}

//GET /get
var mysql=require("mysql");

module.exports=function(req,res){
	var connection=mysql.createConnection({
		host: process.env.OPENSHIFT_MYSQL_DB_HOST,
		port: process.env.OPENSHIFT_MYSQL_DB_PORT,
		user: process.env.OPENSHIFT_MYSQL_DB_USER,
		password: process.env.OPENSHIFT_MYSQL_DB_PASSWORD,
		database: "fliuva"
	});
	connection.query("SELECT * FROM EVENTS",function(err,results,fields){
		res.send(JSON.stringify(results));
	});
}
{% endhighlight  %}

Y en el cliente tratamos los datos. Aquí es donde debemos nosotros mismos crear las estadísticas según las métricas que hayamos definido. Yo solo voy a poner una métrica universal, usuarios por día.

{% highlight js %}
/* Visualization App */
window.addEventListener("load",function(){
	usersPerDay();
	sessionsTable();
});

function id(idx){
	return document.getElementById(idx);
}

function uniqBy(a, key) {
    var seen = {};
    return a.filter(function(item) {
        var k = key(item);
        return seen.hasOwnProperty(k) ? false : (seen[k] = true);
    })
}
function ISODateString(d){
 function pad(n){return n<10 ? '0'+n : n}
 return d.getUTCFullYear()+'-'
      + pad(d.getUTCMonth()+1)+'-'
      + pad(d.getUTCDate());
}

/* Users-per-day */
function usersPerDay(){
	var xhr=new XMLHttpRequest();
	xhr.overrideMimeType("application/json");
	xhr.open("GET","/get");
	xhr.addEventListener("load",function(){
		var json=JSON.parse(xhr.responseText);
		var dataset=new vis.DataSet();
		/*var data=json.filter(function(){
			
		});*/
		var array=uniqBy(json,function(item){
			return item.SESSION;
		}); // Eventos de sesiones repetidas eliminados (mismos usuarios). Ahora tenemos sesiones únicas y tiempos distintos
		for(var i=0;i<array.length;i++)
		{
			var time=new Date(array[i].TIME);
			var date=ISODateString(time); //time.toISOString().substring(0,time.toISOString().indexOf("T"));
			
			var y;
			if(dataset.get(date)==null)
				y=1;
			else
				y=dataset.get(date).y+1;
			
			console.log(date);
			dataset.update({x: date, id: date, y: y});
		}
		var options = {
			catmullRom: false
		};
		var graph2d = new vis.Graph2d(id("users-per-day"), dataset, options);
	});
	xhr.send();
}

/* Table for sessions */

function sessionsTable(){
	var table=document.getElementById("sessions");
	var xhr=new XMLHttpRequest();
	xhr.open("GET","/get");
	xhr.addEventListener("load",function(){
		var json=JSON.parse(xhr.responseText);
		var data=uniqBy(json,function(item){
			return item.SESSION;
		});
		for(var i=0;i<data.length;i++)
		{
			var item=data[i];
			var tr=document.createElement("tr");
			var time=document.createElement("td");
			time.textContent=item.TIME;
			var session=document.createElement("td");
			var link=document.createElement("a");
			link.href="/session/"+item.SESSION;
			link.textContent=item.SESSION;
			session.appendChild(link);
			tr.appendChild(time);
			tr.appendChild(session);
			table.appendChild(tr);
		}
	});
	xhr.send();
}
{% endhighlight  %}

Que se corresponde a este pequeño HTML

{% highlight html %}
<!DOCTYPE html>
<html>
	<head>
		<title>Fliuva - Página principal</title>
		<meta charset="utf-8"/>
		<script src="bower_components/vis/dist/vis.min.js" type="text/javascript"></script>
		<link href="bower_components/vis/dist/vis.min.css" rel="stylesheet" media="all" type="text/css">
		<script src="/app.js"></script>
	</head>
	<body>
		<h1>Fliuva</h1>
		<section>
			<h3>Usuarios por día</h3>
			<div id="users-per-day"></div>
		</section>
		<section>
			<table id="sessions">
				<tr>
					<th>Tiempo</th>
					<th>Sesión</th>
				</tr>
			</table>
		</section>
	</body>
</html>
{% endhighlight  %}

Visualizar cada sesión por separado es posible con la llamada a /session/NOMBRE_DE_SESION

{% highlight js %}
var mysql=require("mysql");

module.exports=function(req,res){
	var session=req.params.session;
	var connection=mysql.createConnection({
		host: process.env.OPENSHIFT_MYSQL_DB_HOST,
		port: process.env.OPENSHIFT_MYSQL_DB_PORT,
		user: process.env.OPENSHIFT_MYSQL_DB_USER,
		password: process.env.OPENSHIFT_MYSQL_DB_PASSWORD,
		database: "fliuva"
	});
	connection.query("SELECT * FROM EVENTS WHERE SESSION = ?",[session],function(err,results){
		if(err)
			res.send(502,"Error: "+err);
		res.render("session.jade",{events: results});
	});
}
{% endhighlight  %}

Y para un rápido procesamiento he decidido usar Jade con JavaScript en el servidor. Y entonces session.jade queda

{% highlight jade %}
doctype html
html
	head
		title Vista de sesión
		meta(charset="utf-8")
	body
		h1 Vista de sesión
		table
			tr
				th Categoría
				th Subcategoría
				th Nombre
				th Descripción
				th Datos
				th Tiempo
			each event in events
				tr
					td= event.CATEGORY
					td= event.SUBCATEGORY
					td= event.NAME
					td= event.DESCRIPTION
					td= event.DATA
					td= event.TIME
{% endhighlight  %}

## Juntando piezas

Por último, la aplicación se tiene que iniciar en algún lado. Server.js contiene el arranque

{% highlight js %}
var express=require("express");
var mysql=require("mysql");
var collect=require("./collect");
var getdata=require("./getdata");
var session=require("./session");
var uuid=require("node-uuid");

var app=express();

app.set("views",__dirname + "/jade");
app.set("view engine","jade");

app.get("/collect",collect);

app.get("/get",getdata);

app.get("/uuid",function(req,res){
	res.send(uuid.v4());
});

app.get("/session/:session",session);

app.use(express.static("www"));

var ip=process.env.OPENSHIFT_NODEJS_IP || process.env.OPENSHIFT_INTERNAL_IP || "127.0.0.1";
var port=process.env.OPENSHIFT_NODEJS_PORT || process.env.OPENSHIFT_INTERNAL_PORT || 8080;

var server=app.listen(port,ip);
{% endhighlight  %}

Y así en un pis pas hemos hecho una aplicación de seguimiento y analíticas en JavaScript. Ahora toca empezar a diseñar estadísticas con los datos que tenemos a nuestra disposición y por supuesto cuando tengamos los datos a obrar en consecuencia.