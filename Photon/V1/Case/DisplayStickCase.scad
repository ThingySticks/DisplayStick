$fn=80;

// Width (Note pcb does not centre align).
width = 56;

// Overall length /mm (without aerial 117mm, With aerial 125mm)
//length = 138;
length = 138 + 45; // with GPS

// Thickness of the base material.
baseHeight = 1.5;

// How height off the base the PCB wil lbe.
// 8mm gives a space for pins on the PCB
// used when piggubacking other pcbs.
//height = 8;
height = 18; // With GPS

//pcbYOffset = 3;
pcbYOffset = 3 + 45; // with GPS

incluedGpsModule = true;
// If including GPS raise height and length

// Diameter of the screw hole for the PCB mounts. 4.4mm works well for M3 heatfits.
pcbMountScrewHoleDiameter = 4.4;

// Diameter of the pins used to locate the PCB instead of screw holes.
pcbMountPinDiameter = 2.8;

module roundedCube(width, height, depth, cornerDiameter) {
//cornerDiameter = 5;
cornerRadius = cornerDiameter/2;

    translate([cornerDiameter/2,0,0]) {
        cube([width-cornerDiameter, height, depth]);
    }
    
    translate([0,cornerDiameter/2,0]) {
        cube([width, height-cornerDiameter, depth]);
    }
    
    translate([cornerRadius,cornerRadius,0]) {
        cylinder(d=cornerDiameter, h=depth);
    }
    
    translate([width-cornerRadius,cornerRadius,0]) {
        cylinder(d=cornerDiameter, h=depth);
    }
    
    translate([cornerRadius,height-cornerRadius,0]) {
        cylinder(d=cornerDiameter, h=depth);
    }
    
    translate([width-cornerRadius,height-cornerRadius,0]) {
        cylinder(d=cornerDiameter, h=depth);
    }
}

module screw(x,y, height) {
    translate([x,y, 0]) {
        cylinder(d=6.5, h=2);
    }
    
    translate([x,y, -4]) {
        cylinder(d=3, h=6);
    }
}

module pcb() {
    cube([50,130,1.6]);
    
    // Photon Screw mount
    screw(25, 14, height, baseHeight);
    
    // Display mounts.
    screw(3,14+36.9, height, baseHeight);
    screw(47,14+36.9, height, baseHeight);
    screw(3,14+36.9+76.1, height, baseHeight);
    screw(47,14+36.9+76.1, height, baseHeight);
}

module photon() {
    cube([20,38,13]);
        
    // USB
    translate([(20 - 8)/2, 0, 13]) {
        cube([8,5.5,3]);
    }
    
    // USB Plug
    translate([(20 - 12)/2, -20, 10]) {
        cube([12,22,7]);
    }
}

module display() {
    cube([50,85,13]);
}

module pcbMount(x,y, height, baseHeight) {
    translate([x,y, baseHeight-0.1]) {
        difference() {
            cylinder(d=8, h=height);
            cylinder(d=pcbMountScrewHoleDiameter, h=height);
        }
    }
}

module pcbMountPin(x,y, height, baseHeight) {
    translate([x,y, baseHeight-0.1]) {
        union() {
            cylinder(d=10, h=height);
            cylinder(d=pcbMountPinDiameter, h=height + 3);
        }
    }
}

module addPcbMounts() {
    // Use pins on the end two to make it easier to 
    
    // Photon Screw mount
    if (!incluedGpsModule) {
        pcbMount(25, 14, height, baseHeight);
    }
    
    // Display mounts.
    pcbMount(3,14+36.9, height, baseHeight);
    pcbMount(47,14+36.9, height, baseHeight);
    pcbMount(3,14+36.9+76.1, height, baseHeight);
    pcbMount(47,14+36.9+76.1, height, baseHeight);
}

module base() {       

    difference() {
        roundedCube(width, length, 10, 4);
        translate([1.5,1.5,baseHeight]) {
            roundedCube(width-3, length-3, 11, 2);
        }
    }
        
    
    translate([3,pcbYOffset,0]) {
        addPcbMounts();
    }
}

base();
showModels();

module showModels() {
    // Wall offset inside the box.
    translate([3,pcbYOffset,0]) {
        translate([0,0, baseHeight + height]) {
            %pcb();
        }

        translate([(50-20)/2, 0,  baseHeight + height + 1.6]) {
            %photon();
        }

        translate([0, 130 - 85, baseHeight + height + 1.6]) {
            %display();
        }
    }
}