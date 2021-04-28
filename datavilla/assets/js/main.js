function hidenav() {
    document.getElementById('tawkchat-minified-box').style.display = 'none';
    document.getElementById('gb-widget-3887').style.display = 'none';


    var myClasses = document.querySelectorAll('.main-header'),
        i = 0,
        l = myClasses.length;

    for (i; i < l; i++) {
        myClasses[i].style.display = 'none';
    }

    var myClasses = document.querySelectorAll('.navbar'),
        i = 0,
        l = myClasses.length;

    for (i; i < l; i++) {
        myClasses[i].style.display = 'none';
    }

    var myClasses = document.querySelectorAll('.sidebar'),
        i = 0,
        l = myClasses.length;

    for (i; i < l; i++) {
        myClasses[i].style.display = 'none';
    }




}



hidenav();