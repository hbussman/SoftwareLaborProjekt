<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Betriebsfeier</title>

    <style>
        .navbar-center {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
        
        html 
		{
		 	overflow: auto;
		}
 
		html, body, div, iframe 
		{
 			margin: 0px; 
 			padding: 0px; 
 			height: 100%; 
 			border: none;
		}
 
		iframe 
		{
 			display: block; 
 			width: 100%; 
 			border: none; 
 			overflow-y: auto; 
 			overflow-x: hidden;
		}
    </style>
    

</head>
<body>
<nav class="navbar fixed-top navbar-dark bg-dark" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">${event.name}</p>
</nav>
<nav class="navbar fixed-bottom navbar-expand-lg navbar-dark bg-dark justify-content-center">
    <div class="btn-group" role="group" aria-label="Basic example" style="min-width: 100%">
        <a class="btn btn-primary btn-light" href="${context}/attractions" role="button"><i class="fas fa-landmark"></i></a>
        <a class="btn btn-primary btn-light disabled" aria-disabled="true" href="${context}/sponsoren"
           style="background: aquamarine"><i class="fas fa-home"></i></a>
        <a class="btn btn-primary btn-light" href="${context}/events" role="button"><i class="far fa-calendar-alt"></i>
        </a>
    </div>
</nav>
	
	<iframe src="https://seserver.se.hs-heilbronn.de:3000/api/map/lon=9.20935&lat=49.14788" frameborder="0" style="width: 100%; height: 100%">
	</iframe>
	</body>
</html>