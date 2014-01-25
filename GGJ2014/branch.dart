part of game;

class Branch extends Sprite {
    bool isRoot = false;

    num _water = 0;
    num _old_water = 0;
    void set water(num water) {
        _old_water = _water;
        _water = water;
    }
    num get water => _water;

    num _energy = 0;
    num _old_energy = 0;
    void set energy(num energy) {
        _old_energy = _energy;
        _energy = energy;
    }
    num get energy => _energy;

    num wither = 0;

    num baseRotation = 0.0;

    num _valve = 1;
    num set valve(num value) {
        num diff = value - _valve;
        _valve = value;
        if(parent is Branch) {
            for(var b in parent.branches) {
                if(!identical(b, this)) {
                    b._valve -= diff / (parent.branches.length - 1);
                }
            }
        }
    }
    num get valve => _valve;

    bool isDragging = false;
    Vector dragStartPoint = null;

    int branchColor = 0;

    GlassPlate shape = null;
    Shape debugShape = null;
    TextField branchText = new TextField();

    num _length = 1;
    num set length(num value) {
        _length = value;
        reset();
    }
    num get length => _length;

    num _thickness = 1;
    num set thickness(num value) {
        _thickness = value;
        reset();
    }
    num get thickness => _thickness;

    Branch(this._thickness) {
        water = parent != null ? parent.water/2 : thickness;
        energy = parent != null ? parent.energy/2 : thickness;
        reset();

        onEnterFrame.listen(_onEnterFrame);

        branchText.defaultTextFormat = new TextFormat('monospace', 10, Color.White);
        branchText.scaleX = 0.01;
        branchText.scaleY = 0.01;
        branchText.y = -0.5;
        branchText.x = 0.02;
        branchText.text = "branchText";
        branchText.mouseEnabled = false;
        this.mouseEnabled = false;
        addChild(branchText);

        var waterConfig = {"maxParticles":100, "duration":0, "lifeSpan":5, "lifespanVariance":0, "startSize":0, "startSizeVariance":10, "finishSize":0, "finishSizeVariance":10, "shape":"circle", "emitterType":0, "location":{"x":0, "y":0}, "locationVariance":{"x":5, "y":5}, "speed":100, "speedVariance":0, "angle":0, "angleVariance":0, "gravity":{"x":0, "y":0}, "radialAcceleration":0, "radialAccelerationVariance":0, "tangentialAcceleration":0, "tangentialAccelerationVariance":0, "minRadius":0, "maxRadius":0, "maxRadiusVariance":0, "rotatePerSecond":0, "rotatePerSecondVariance":0, "compositeOperation":"source-over", "startColor":{"red":0, "green":0.4, "blue":0.9, "alpha":0.6}, "finishColor":{"red":0, "green":0.4, "blue":0.9, "alpha":0.6}};

        var waterEmitter = new ParticleEmitter(waterConfig);
        waterEmitter.setEmitterLocation(0, 3);
        waterEmitter.scaleX = 0.002;
        waterEmitter.scaleY = 0.002;
        waterEmitter.rotation = -PI/2;
        addChild(waterEmitter);
        stage.juggler.add(waterEmitter);

        var energyConfig = {"maxParticles":100, "duration":0, "lifeSpan":5, "lifespanVariance":0, "startSize":0, "startSizeVariance":10, "finishSize":0, "finishSizeVariance":10, "shape":"circle", "emitterType":0, "location":{"x":0, "y":0}, "locationVariance":{"x":5, "y":5}, "speed":100, "speedVariance":0, "angle":0, "angleVariance":0, "gravity":{"x":0, "y":0}, "radialAcceleration":0, "radialAccelerationVariance":0, "tangentialAcceleration":0, "tangentialAccelerationVariance":0, "minRadius":0, "maxRadius":0, "maxRadiusVariance":0, "rotatePerSecond":0, "rotatePerSecondVariance":0, "compositeOperation":"source-over", "startColor":{"red":0, "green":0.9, "blue":0.2, "alpha":0.6}, "finishColor":{"red":0, "green":0.9, "blue":0.2, "alpha":0.6}};

        var energyEmitter = new ParticleEmitter(energyConfig);
        energyEmitter.setEmitterLocation(-500, -3);
        energyEmitter.scaleX = 0.002;
        energyEmitter.scaleY = 0.002;
        energyEmitter.rotation = PI/2;
        addChild(energyEmitter);
        stage.juggler.add(energyEmitter);
    }

    void reset() {
        // click shape
        if(shape != null) removeChild(shape);
        shape = new GlassPlate(thickness, length);
        shape.pivotX = thickness/2;
        shape.pivotY = length;
        addChild(shape);

        // debug shape
        // if(debugShape != null) removeChild(debugShape);
        // debugShape = new Shape();
        // debugShape.graphics.rect(-thickness/2, -length, thickness, length);
        // debugShape.graphics.strokeColor(0xFF00FF00, 0.01);
        // addChild(debugShape);

        y = parent is Branch ? -parent.length : 0;

        for(var b in branches) {
            b.reset();
        }
    }

    num get totalValve => parent is Branch ? parent.totalValve * valve : valve;

    int get depth => parent is Branch ? parent.depth + 1 : 0;

    bool get isBase => !(parent is Branch);

    bool get isEndBranch => branches.length == 0;

    List<Branch> get branches {
        List<Branch> result = new List<Branch>();
        for(int i = 0; i < numChildren; i++) {
            if(getChildAt(i) is Branch) result.add(getChildAt(i));
        }
        return result;
    }

    List<Leaf> get leaves {
        List<Leaf> result = new List<Leaf>();
        for(int i = 0; i < numChildren; i++) {
            if(getChildAt(i) is Leaf) result.add(getChildAt(i));
        }
        return result;
    }

    void growLeaves([int num = 30]) {
        for(int i = 0; i < num; ++i) {
            addChild(new LeafBranch(this));
        }
    }

    void _onEnterFrame(EnterFrameEvent e) {
        e = new EnterFrameEvent(e.passedTime * 5);
        
        // Update gameplay values
        num energyFactor = 0.05;
        num energyToWater = 1; 
        num thirstiness = 0.001;
        num witherFactor = 0.5;
        num energyConversionRate = 0.01;
        num transferRate = 0.01;
        num transferFactor = 1;

        // Energy is generated by leaves when sun is alight
        // For now just give it a fix value
        if(isEndBranch) {
            energy = (energy + e.passedTime * energyFactor).clamp(0, 1);
            water -= e.passedTime * thirstiness;
            if(water < 0) {
                wither -= water * witherFactor;
                water = 0;
            }
        }

        // Generate water in root
        if(isRoot) {
            num de = min(energy, energyConversionRate);
            energy -= de;
            water = (water + de * energyToWater).clamp(0, 1);
        }

        for(var child in branches) {
            num de = child.energy * valve * e.passedTime * transferRate;
            energy += de;
            child.energy -= de;

            num dw = (valve * e.passedTime * transferRate) / branches.length;
            dw = min(dw, water);
            dw = min(dw, 1 - child.water);
            water -= dw;
            child.water = (child.water + dw * transferFactor);
        }

        // Update debug info
        branchText.textColor = Color.Red;
        branchText.text = "D: ${depth}";
        branchText.text += "\nW: ${water.toStringAsFixed(3)}";
        branchText.text += "\nE: ${energy.toStringAsFixed(3)}";
        branchText.text += "\nV: ${valve.toStringAsFixed(3)}";
        branchText.text += "\nW: ${wither.toStringAsFixed(3)}";
        branchText.visible = debug;

        if(isRoot) {
            this.rotation = baseRotation;
        } else {
            this.rotation = baseRotation + Wind.power * 0.2;
        }

        num st = startThickness;
        num et = thickness;

        this.graphics.clear();

        if(isBase) {
            Spline spline = new Spline();
            addPoints(spline, this);
            spline.generatePath(graphics);
            graphics.fillColor(0xFF000000);
            graphics.strokeColor(0x55FFFFFF, 0.01);
        } else if(isEndBranch) {
            Spline spline = new Spline();
            addVeinPoints(spline, this, null, 0);
            spline.generatePath(graphics);
            graphics.strokeColor(new AwesomeColor(1, 1, 1, totalValve).hex, 0.01);
        }

        branchColor = (new AwesomeColor.fromHex(0x22DDFFDD) * Environment.getLightColorFor(this)).hex;
    }

    void addPoints(Spline spline, Branch base) {
        num st = startThickness;
        num et = thickness;

        num tangentLength = isEndBranch ? 0.0 : 0.2 * length;

        // going up on the left
        if(isBase) {
            spline.add(base.globalToLocal(localToGlobal(new Point(-st/2,  0))), 0.1);
        }
        spline.add(base.globalToLocal(localToGlobal(new Point(-et/2, -length))), tangentLength);

        // sort children
        sortChildren((var l, var r) {
            if(l is Branch && r is Branch) {
                return l.baseRotation.compareTo(r.baseRotation);
            } else {
                return 0;
            }
        });

        int numBranches = branches.length;
        int branchNumber = 0;
        for(Branch branch in branches) {
            if(branchNumber > 0) {
                spline.add(base.globalToLocal(localToGlobal(new Point(et*(branchNumber*1.0/numBranches - 0.5), -length-0.1))), 0.0);
            }
            branch.addPoints(spline, base);
            branchNumber++;
        }

        // going down on the right
        spline.add(base.globalToLocal(localToGlobal(new Point(et/2, -length))), tangentLength);
        if(isBase) {
            spline.add(base.globalToLocal(localToGlobal(new Point(st/2, 0))), 0.1);
        }
    }

    void addVeinPoints(Spline spline, Branch end_branch, Branch from, num offset) {
        num tangentLength = 0.2*length;

        if(from != null) {
            int index = this.branches.indexOf(from) + 1;
            offset += ((index/(this.branches.length+1))-0.5)*thickness;
            debugMessage = "$offset";
        }
        spline.add(end_branch.globalToLocal(localToGlobal(new Point(offset, -length))), tangentLength);
        if(!isBase) {
            this.parent.addVeinPoints(spline, end_branch, this, offset);
        } else {
            spline.add(end_branch.globalToLocal(localToGlobal(new Point(offset * 0.5, 0))), tangentLength);
        }
    }

    num get startThickness => isBase ? thickness : parent.thickness;

    num get absoluteAngle => isBase ? rotation : parent.rotation + rotation;

    void dragStart(MouseEvent event) {
        isDragging = true;
        dragStartPoint = new Vector(mouseX, mouseY);

        print("Drag start");
    }

    void dragInProgress(MouseEvent event) {
        event.stopPropagation();

        if(isDragging) {
            if(mode == "valve") {
                valve = (valve - (mouseY - dragStartPoint.y)).clamp(0, 1);
                dragStartPoint = new Vector(mouseX, mouseY);
            }
        }
    }

    void dragStop(MouseEvent event) {
        if(!isDragging) return;
        isDragging = false;

        if(mode == "branch") {
            var mouse = new Vector(mouseX, mouseY);
            growChild(mouse.rads);
        }

        print("Drag stop");
    }

    void growChild(num absolute_angle) {
        Branch b = new Branch(thickness * 0.5);
        b.rotation = absolute_angle - this.absoluteAngle;
        addChild(b);
    }

    Vector getTipPosition() {
        var p = view.globalToLocal(localToGlobal(new Point(0, 0)));
        return new Vector(p.x, p.y);
    }
}
