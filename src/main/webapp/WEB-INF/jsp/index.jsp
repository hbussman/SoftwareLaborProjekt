<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE HTML>
<html>
<head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- Bootstrap CSS -->
    <link rel="stylesheet"
          href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
          integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
          crossorigin="anonymous">

    <!-- own scripts -->
    <script src="/js/api_client.js"></script>

    <title>Sponsoren Early Prototyp</title>
</head>
<body>

    <!-- Temporary redirect until the index page is done -->
    <script>
        document.location = "/sponsoren";
    </script>


    <div class="collapse navbar-collapse" id="navbarTogglerDemo02">
        <ul class="navbar-nav mr-auto mt-2 mt-lg-0">
            <li class="nav-item active">
                <a class="nav-link" href="sponsoren">Home <span class="sr-only">(current)</span></a>
            </li>
            <li class="nav-item active">
                <a class="nav-link" href="/webinterface/webinterface-login.html">Login <span class="sr-only">(current)</span></a>
            </li>
        </ul>
    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <%--@elvariable id="sponsors" type="java.util.List"--%>
        <c:forEach items="${sponsors}" var="sponsor">
            <div class="col-lg-2 col-md-3 col-sm-6 pb-md-4 pb-sm-3">
                <div class="card">
                    <img src="img/${sponsor.name}_scaled.png" class="card-img-top" alt="${sponsor.name}Logo">
                    <div class="card-body">
                        <h5 class="card-title">${sponsor.name}</h5>
                        <a href="/sponsor?name=${sponsor.name}" class="btn btn-dark">Mehr erfahren</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

</body>
</html>
