// This file contains all the parts for a rack enclosure
// It has the format required for a customizable project on Thingiverse
// Note: Calculated variables does not show up in the customizer, hence the *1;

// This variable tells OpenSCAD
$fn = 50*1;

// a:Extrusion no holes
// b:Extrusion front holes
// c:Extrusion front and side holes
// d:End open
// e:End grid
// f:End chimney
// g:End closed
// h:Nut-less Trap
// i:Panel
// j:Panel with handle
// k:Handle
part = "k";

Units = 3;

m3_screw_diameter = 2.43;
m4_screw_diameter = 3.22;
m5_screw_diameter = 4.11;

center_hole_diameter = m5_screw_diameter;
side_hole_diameter = m3_screw_diameter;

//Constants, do not change!
EXTERIOR_WIDTH  = 155*1;       // cm = 6"
INTERIOR_WIDTH  = 155-20-20;   // 11.5cm between rails
UNIT_HEIGHT     = (44.5/19)*6; // 1U = 14.05cm
GAUGE           = 3*1;
GAUGE_BOX       = 2*1;
SLIP            = 0.35*1;      // extra slip between parts

go();

module go() {
    if (part=="a") {
        extrusion(Units, true, false, false. center_hole_diameter. side_hole_diameter);
    } else if (part=="b") {
        extrusion(Units, true, true, false, center_hole_diameter, side_hole_diameter);
    } else if (part=="c") {
        extrusion(Units, true, true, true, center_hole_diameter, side_hole_diameter);
    } else if (part=="d") {
        rack_end(0);
    } else if (part=="e") {
        rack_end(1);
    } else if (part=="f") {
        rack_end(2);
    } else if (part=="g") {
        rack_end(3);
    } else if (part=="h") {
        trap(Units);
    } else if (part=="i") {
        sidepanel(Units, false);
    } else if (part=="j") {
        sidepanel(Units, true);
    } else if (part=="k") {
        tophandle();
        translate([0,30,0]) {
            tophandle();
        }
    }
}

module chimney() {
    for(i=[0:8:80]) {
        echo(i);
        translate([20 + (INTERIOR_WIDTH-80)/2  +i,-1,20]) {
            minkowski() {
                cube([0.01,50,30]);
                sphere(d=2,h=1);
            }
        }
    }
}

// Nut-less Trap
module trap(u) {
    difference() {
        union() {
            translate([-2.4,0,4]) {
                cube([4.8,UNIT_HEIGHT*u,1.5]);
            }
            translate([-2.4,UNIT_HEIGHT*u,0]) {
                rotate([90,0,0]) {
                    linear_extrude(UNIT_HEIGHT*u) {
                        polygon(points=[[0,0],[4.8,0],[7,4],[-2.2,4]]);
                    }
                }
            }
        }
        for(i=[1:u]) {
            translate([0,UNIT_HEIGHT*i-UNIT_HEIGHT/2,-1]) {
                cylinder(d=m4_screw_diameter,h=10);
            }
        }
    }
}

//0: open
//1: grid
//2: chimney
//3: closed
module rack_end(type) {
    INTERIOR_WIDTH = EXTERIOR_WIDTH+1;
    difference() {
        union() {
            translate([1.25,1.25,1.25]) {
                minkowski() {
                    w = INTERIOR_WIDTH-2.5;
                    cube([w, w, GAUGE-2.5]);
                    sphere(r=1.25);
                }
            }
        }
        if(type==0 || type==1) {
            translate([20,20,-1]) {
                cube([INTERIOR_WIDTH-40,INTERIOR_WIDTH-40,GAUGE+2]);
            }
        }

        translate([10,10,-0.1])                {
            cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);
        }
        translate([INTERIOR_WIDTH-10,10,-0.1])        {
            cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);
        }
        translate([10,INTERIOR_WIDTH-10,-0.1])        {
            cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);
        }
        translate([INTERIOR_WIDTH-10,INTERIOR_WIDTH-10,-0.1]) {
            cylinder(d=5,h=10); cylinder(d1=10,d2=6,h=3.5);
        }

        rotate([-90,0,0]) {
            if(type==2) {
                translate([0,-5,0]) {
                    chimney();
                }
                translate([0,-5,(INTERIOR_WIDTH-29)/2]) {
                    chimney();
                }
                translate([0,-5,INTERIOR_WIDTH-29]) {
                    chimney();
                }
            }
        }
    }
    if(type==1) {
        intersection() {
            union() {
                sz=8;
                grid = 15;
                for(i=[-grid*8:12:grid*8]) {
                    translate([sz/2+i+70,sz/2+78,GAUGE/2]) {
                        rotate([0,0,45]) {
                            cube([2,INTERIOR_WIDTH*1.5,GAUGE],center=true);
                        }
                    }
                    translate([sz/2+i+70,sz/2+82,GAUGE/2]) {
                        rotate([0,0,-45]) {
                            cube([2,INTERIOR_WIDTH*1.5,GAUGE],center=true);
                        }
                    }
                }
            }
            translate([15,15,-1]) {
                cube([125,125,10]);
            }
        }
    }
}

module tophandle() {
    rotate([0,180,0]) {
        difference() {
            union() {
                rotate([0,45,0]) {
                    extrusion_base(4,false,false,false);
                }
                translate([EXTERIOR_WIDTH,20,0]) {
                    rotate([0,45,180]) {
                        extrusion_base(4,false,false,false);
                    }
                }
            }
            wedge();
            translate([90,90,10]) {
                cube([200,200,20],center=true);
            }
            translate([10,10,0]) {
                handlescrew();
            }
            translate([EXTERIOR_WIDTH-10,10,0]) {
                handlescrew();
            }
        }
        intersection() {
            translate([0,0,-27.4]) {
                extrusion_base(11,false,false,false);
            }
            wedge();
        }
    }
}

module handlescrew() {
    translate([0,0,-39]) {
        cylinder(d=5,h=40);
    }
    translate([0,0,-4]) {
        cylinder(d1=10,d2=6,h=3.5);
    }
    translate([0,0,-34]) {
        cylinder(d=10,h=30);
    }
}

module wedge() {
    translate([EXTERIOR_WIDTH/2,-10,15]) {
        rotate([0,45+45/2,0]) {
            cube([80,80,30]);
        }
        translate([0,80,0]) {
            rotate([0,45+45/2,180]) {
                cube([80,80,30]);
            }
        }
        translate([-20,0,-100]) {
            cube([40,80,100]);
        }
    }
}

module extrusion(u, has_center_hole, has_front_holes, has_side_holes, center_hole_diameter, side_hole_diameter) {
    rotate(a = [270, 270, 0]) {
        extrusion_base(u, has_center_hole, has_front_holes, has_side_holes, center_hole_diameter, side_hole_diameter);
    }
}

module extrusion_base(u, has_center_hole, has_front_holes, has_side_holes, center_hole_diameter, side_hole_diameter) {difference() {
    len = UNIT_HEIGHT * u;
    translate([0,2,2]) {
        minkowski() {
            cube([len,16,16]);
            sphere(d = 4);
        }
    }
    translate([-5,10,1.99]) {
        rotate([0,90,0]) {
            linear_extrude(len+10) {
                polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
            }
        }
    }
    translate([-5,10,18.01]) {
        rotate([0,-90,180]) {
            linear_extrude(len+10) {
                polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
            }
        }
    }
    translate([-5,18.01,10]) {
        rotate([90,0,90]) {
            linear_extrude(len+10) {
                polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
            }
        }
    }
    translate([-5,1.99,10]) {
        rotate([-90,0,-90]) {
            linear_extrude(len+10) {
                polygon(points=[[0,-2.5],[2,-4],[2,4],[0,2.5]]);
            }
        }
    }
    if(has_center_hole) {
        translate([-5,10,10]) {
            rotate([0,90,0]) {
                cylinder(d=center_hole_diameter,h=len+10);
            }
        }
    }
    //holes
    if(has_front_holes) {
        for(i=[0:30]) {
            translate([UNIT_HEIGHT/2+i*UNIT_HEIGHT,10,-5]) {
                cylinder(d=side_hole_diameter,h=30);
            }
        }
    }
    if(has_side_holes) {
        for(i=[0:30]) {
            translate([UNIT_HEIGHT/2+i*UNIT_HEIGHT,25,10]) {
                rotate([90,0,0]) {
                    cylinder(d=side_hole_diameter,h=30);
                }
            }
        }
    }
    //length cutoff
    translate([-2,0,0]) {
        cube([4,60,60],center=true);
    }
    translate([len+2,0,0]) {
        cube([4,60,60],center=true);
    }
}
}

module screw() {
    cylinder(r1=screw_head/2, r2=screw_dia/2, h=screw_head_height);
    cylinder(r=screw_dia/2, h=40);
    translate([0,0,-0.99]) {
        cylinder(r=screw_head/2, h=1);
    }
}

module insideprofile(l) {
    difference() {
        union() {
            translate([7.6,10,0]) {
                cube([4.8,10,l]);
            }
            translate([0,7.6,0]) {
                cube([20,4.8,l]);
            }

            translate([6.5,10-2.1,0]) {
                cube([7,10,l]);
            }
            translate([2.1,6.5,0]) {
                cube([15.8,7,l]);
            }
        }
        translate([4,4,-1]) {
            cube([12,12,l+2]);
        }
    }
    translate([20,20,0]) {
        rotate([0,-90,0]) {
            linear_extrude(20) {
                polygon (points=[[0,0],[l,0],[0,l]]);
            }
        }
    }
}

module sidepanel(u,handle) {
    difference() {
        baseplate(u);
        if(handle) {
            translate([(EXTERIOR_WIDTH-80)/2,         9,-4]) {
                cube([80,20,10]);
            }
            translate([(EXTERIOR_WIDTH-80)/2,        19,-4]) {
                cylinder(d=20,h=10);
            }
            translate([EXTERIOR_WIDTH-(EXTERIOR_WIDTH-80)/2,19,-4]) {
                cylinder(d=20,h=10);
            }
        }
    }
}

module baseplate(u) {
    difference() {
        union() {
            translate([1.25,1.25,1.25]) {
                minkowski() {
                    cube([EXTERIOR_WIDTH-2.5,UNIT_HEIGHT*u-2.5,GAUGE-2.5]);
                    sphere(r=1.25);
                }
            }
        }
        //Rack mount holes
        translate([10-0.5,UNIT_HEIGHT/2,-GAUGE/2])                 {
            cylinder(r=2.3,GAUGE*2);
        }
        translate([EXTERIOR_WIDTH-10+0.5,UNIT_HEIGHT/2,-GAUGE/2])         {
            cylinder(r=2.3,GAUGE*2);
        }
        translate([10-0.5,u*UNIT_HEIGHT-(UNIT_HEIGHT/2),-GAUGE/2])        {
            cylinder(r=2.3,GAUGE*2);
        }
        translate([EXTERIOR_WIDTH-10+0.5,u*UNIT_HEIGHT-(UNIT_HEIGHT/2),-GAUGE/2]) {
            cylinder(r=2.3,GAUGE*2);
        }
        if(u>=5) {
            translate([10-0.5,(u*UNIT_HEIGHT)/2,-GAUGE/2])         {
                cylinder(r=2.3,GAUGE*2);
            }
            translate([EXTERIOR_WIDTH-10+0.5,(u*UNIT_HEIGHT)/2,-GAUGE/2]) {
                cylinder(r=2.3,GAUGE*2);
            }
        }
    }
}
