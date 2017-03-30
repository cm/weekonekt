require('./img/slider/slider-01.jpg')
require('./fonts/fontawesome-webfont.eot')
require('./fonts/fontawesome-webfont.svg')
require('./fonts/fontawesome-webfont.ttf')
require('./fonts/fontawesome-webfont.woff')
require('./fonts/fontawesome-webfont.woff2')
require('./fonts/glyphicons-halflings-regular.eot')
require('./fonts/glyphicons-halflings-regular.svg')
require('./fonts/glyphicons-halflings-regular.ttf')
require('./fonts/glyphicons-halflings-regular.woff')
require('./fonts/glyphicons-halflings-regular.woff2')
require('./fonts/revicons.eot')
require('./fonts/revicons.svg')
require('./fonts/revicons.ttf')
require('./fonts/revicons.woff')
require('./css/bootstrap.min.css')
require('./css/font-awesome.min.css')
require('./css/datepicker.css')
require('./css/isotope.css')
require('./css/jquery-ui.css')
require('./css/jquery.fancybox.css')
require('./css/select_option1.css')
require('./css/settings.css')
require('./css/style.css')
require('jquery')
require('./js/jquery-ui.js')
require('./js/bootstrap.min.js')
require('./js/jquery.themepunch.tools.min.js')
require('./js/jquery.themepunch.revolution.min.js')
require('./js/jquery.selectbox-0.1.3.min.js')
require('bootstrap-datepicker')
require('./js/waypoints.min.js')
require('./js/jquery.counterup.min.js')
require('./js/isotope.min.js')
require('./js/jquery.fancybox.pack.js')
require('./js/isotope-triger.js')
require('./js/jquery.syotimer.js')
require('./js/SmoothScroll.js')
require('./js/custom.js')

const Elm = require('./elm/Main.elm');
const mountNode = document.getElementById('main');
const app = Elm.Main.embed(mountNode);


if (module.hot) {
    module.hot.accept()
}

