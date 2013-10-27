var Enemy = Class.create(Entity, {
    className: "Enemy",
    initialize: function($super, posX, posZ) {
        $super();
        this.velocity = new THREE.Vector3(0, 0, 0);
        this.acceleration = 20;
        this.damping = 20;

        // create the mesh
        var material = new THREE.MeshLambertMaterial({color: 0x0FF0000});
        this.mesh = new THREE.Mesh(new THREE.CubeGeometry(0.1, 0.3, 0.1), material);
        this.mesh.position.x = posX;
        this.mesh.position.z = posZ;
        this.mesh.castShadow = true;
        this.mesh.receiveShadow = true;
    },

    onAdd: function(scene) {
        scene.add(this.mesh);
    },

    onRemove: function(scene) {
        scene.remove(this.mesh);
    },

    update: function(dt) {
        this.setBox(this.mesh.position, new THREE.Vector3(0.2, 1, 0.2));

        var tank = this.game.scene.getObjectByName("tank");

        var vec = tank.position.clone().sub(this.mesh.position);
        var angle = -Math.atan2(vec.z, vec.x);

        vec.normalize();
        
        this.velocity.add(vec.multiplyScalar(dt * this.acceleration));

        this.velocity.multiplyScalar(Math.max(0, 1 - this.damping * dt));
        this.mesh.position.add(this.velocity.clone().multiplyScalar(dt));
    }
});