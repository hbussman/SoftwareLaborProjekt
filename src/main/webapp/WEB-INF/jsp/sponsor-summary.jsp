<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--@elvariable id="util" type="sponsoren.Util"--%>
<%--@elvariable id="sponsorsSorted" type="java.util.List<java.util.List<sponsoren.orm.SponsorEntity>>"--%>
<%--@elvariable id="searchString" type="java.lang.String"--%>
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
        .navbar-center {
            position: absolute;
            overflow: visible;
            height: 0;
            width: 100%;
            left: 0;
            top: 0;
            text-align: center;
        }

        .bg-image {
            background-image: url(https://imgur.com/LkSvZHY.jpg);
            height: 100%;
            background-position: bottom center;
            background-attachment: fixed;
            background-repeat: no-repeat;
            background-size: cover;
        }
    </style>
</head>

<body class="bg-image">

<nav class="navbar fixed-top navbar-dark bg-dark" style="min-height: 50px">
    <p class="navbar-text navbar-center text-white" style="font-size: x-large">Sponsoren</p>
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

<div class="container-fluid pt-5 pb-5">
    <c:forEach items="${sponsorsSorted}" var="sponsorlist">
        <div class="row no-gutters justify-content-center">
            <c:forEach items="${sponsorlist}" var="sponsor">
                <c:if test="${util.searchMatch(searchString, sponsor)}">

                    <div class="col d-flex align-items-stretch col-lg-3 col-md-3 col-sm-4 col-6 py-md-4 px-md-4 py-sm-3  px-sm-3 py-2  px-2">

                        <div class="card bg-light shadow rounded">
                            <a id="${sponsor.name}-image" href="${context}/sponsor?name=${sponsor.name}">
                                <img src="${context}/image/${sponsor.name}_scaled.png" class="card-img-top"
                                     alt="${sponsor.name}-Logo">
                            </a>
                            <a id="${sponsor.name}-title" href="${context}/sponsor?name=${sponsor.name}"
                               class="card-body text-dark">${sponsor.name}</a>
                        </div>

                    </div>
                </c:if>
            </c:forEach>

        </div>
        <div class="col col-12 justify-content-center py-md-4 px-md-4 py-sm-3  px-sm-3 py-2  px-2">
            <div class="border-top"></div>
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
