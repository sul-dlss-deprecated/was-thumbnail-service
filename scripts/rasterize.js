var page = require('webpage').create(),
    system = require('system'),
    address, output, size;

if (system.args.length < 3 || system.args.length > 5) {
    console.log('Usage: rasterize.js URL filename [paperwidth*paperheight|paperformat] [zoom]');
    console.log('  paper (pdf output) examples: "5in*7.5in", "10cm*20cm", "A4", "Letter"');
    phantom.exit(1);
} else {
    address = system.args[1];
    output = system.args[2];
    page.viewportSize = { width: 1000, height: 1000 };
    if (system.args.length > 3) {
        size = system.args[3].split('*');
        page.paperSize = size.length === 2 ? { width: size[0], height: size[1], margin: '0px' }
                                           : { format: system.args[3], orientation: 'portrait', margin: '1cm' };
    }
    if (system.args.length > 4) {
        page.zoomFactor = system.args[4];
    }
    
    general_result = true;
    general_http_status = 200;
    general_http_message = "OK";
    required_id = 1;
    general_status = true;
    page.onResourceReceived=function(response) {
    		if(response.id == required_id && response.status >= 400 && response.stage=='end'){
    			general_status = false;
    			general_http_status = response.status;
    			general_http_message = response.statusText;
    		} else if(response.id == required_id && response.status >= 300 && response.status <400 && response.stage=='end'){
    			required_id = required_id + 1
    		}
	};
    page.open(address, function (status) {
        if (status !== 'success' || general_status == false) {
            console.log('#FAIL# Unable to load the address! with HTTP status: '+general_http_status+", HTTP message: "+general_http_message);
            phantom.exit();
        } else {
            page.evaluate(function() {
                $( "#wm-ipp" ).remove();
            });
            window.setTimeout(function () {
                page.render(output);
                phantom.exit();
            }, 200);

        }
    });
}
