<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="context" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.8.1/css/all.css"
          integrity="sha384-50oBUHEmvpQ+1lW4y57PTFmhCaXp0ML5d60M1M7uH2+nqUivzIebhndOJK28anvf" crossorigin="anonymous">

    <!-- own scripts -->
    <script src="${context}/js/api_client.js"></script>
    <script>api_set_context("${context}")</script>

    <title>Sponsoren-Startseite</title>
    <style>
        .navbar-center
        {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }
    </style>
</head>

<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <p class="navbar-text navbar-center text-white">Sponsoren</p>
    <a class="btn btn-primary btn-secondary" href="${context}/sponsoren"><i class="fas fa-home"></i></a>
    <ul class="nav navbar-nav ml-auto "></ul>
    <a class="btn btn-primary btn-secondary" href="${context}/events" role="button"><i class="far fa-calendar"></i>
    </a>
</nav>

<div class="container-fluid pt-1">
   

        <%--@elvariable id="sponsorsSorted" type="java.util.List"--%>
        <c:forEach items="${sponsorsSorted}" var="sponsorlist">
         <div class="row no-gutters">
         <c:forEach items="${sponsorlist}" var="sponsor">
            <div class="col d-flex align-items-stretch col-lg-2 col-md-3 col-sm-4 col-6 pb-md-4 pb-sm-3 pl-md-4 pl-sm-3 px-1 py-1">

                    <div class="card">
                        <img src="${imagesBase}/${sponsor.name}_scaled.png" class="card-img-top"
                             alt="${sponsor.name}-Logo">
                        <div class="card-body pb-0">
                            <h5 class="card-title">${sponsor.name}</h5>
                        </div>
                        <div class="card-footer px-0 py-0 border-0 ">
      						<a href="${context}/sponsor?name=${sponsor.name}" class="btn btn-dark w-100">Mehr erfahren</a>
    					</div>
                    </div>
            </div>
        </c:forEach>
          <div class="col  col-12 px-1 py-1 ">
        			<div class="card"></div>
         </div>
         </div>
        </c:forEach>

    
</div>


<!-- Optional JavaScript -->
<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"
        integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo"
        crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>

</body>
</html>
