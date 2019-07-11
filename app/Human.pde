public class Human {

    boolean sex, gender, loveTarget;
    boolean isAbleToMarry, isMarried, isAbleToReproduction, isDead;
    Human partner;
    int age;
    PVector position, velocity;
    
    public Human (boolean s, boolean g, boolean lT) {
        this.sex = s;
        this.gender = g;
        this.loveTarget = lT;

        this.isAbleToMarry = false;
        this.isMarried = false;
        this.isAbleToReproduction = false;
        this.isDead = false;
        int age = 0;

        position = new PVector(0,0);
        velocity = new PVector(0,0);       
    }

    public void setFirstPosition(){
        setRandomPosition();
        setRandomVelocity();
    }

    void setRandomPosition(){
        this.position.x = random(800);
        this.position.y = random(450);
    }

    void setRandomVelocity(){
        this.velocity.x = random(-16, 16);
        this.velocity.y = random(-9, 9);
    }

    public void setPositionCenter(Human father, Human mother){
        this.position.x = (father.position.x + mother.position.x) * 0.5;
        this.position.y = (father.position.y + mother.position.y) * 0.5;

        this.setRandomVelocity();
    }

    public void aging(int limitAge){
        this.age +=1;
        if (this.age > limitAge){
            this.isAbleToReproduction = false;
        }
    }

    public void checkAlive(int deathAge){
        if(this.age > deathAge){
            this.isDead = true;
        }
    }

    public boolean checkDistance(Human otherHuman, int maxDistance){
        double dist = dist(this.position.x, this.position.y, otherHuman.position.x, otherHuman.position.y);

        if(dist < maxDistance){
            return true;
        }else{
            return false;
        }
    }

    public void setToBeAbleToMarry(){
        this.isMarried = false;
        this.isAbleToMarry = true;
        this.isAbleToReproduction = false;
    }

    public void marry(Human partner, int limitAge){
        this.isMarried = true;
        this.isAbleToMarry = false;
        if (this.age < limitAge){
            this.isAbleToReproduction = true;
        }
        this.partner = partner;
    }

    public Human checkPartner(){
        return this.partner;
    }

    public Human reproduction(float r_GIDisorder, float r_Homosexual){
        if(this.isMarried && this.isAbleToReproduction){
            Human partner = this.partner;
            boolean sex_c, gender_c, loveTarget_c;

            if(!this.sex && !partner.sex){
                sex_c = false;
            } else {
                float r1 = random(100) /100;
                if(r1 < 0.5){
                    sex_c = true;
                } else {
                    sex_c = false;
                }
            }

            float r2 = random(100) /100;
            if(r2 < r_GIDisorder){
                gender_c = !sex_c;
            } else {
                gender_c = sex_c;
            }

            if(this.gender != this.loveTarget && partner.gender != partner.loveTarget){
                float r3 = random(100) /100;
                if(r3 < r_Homosexual){
                    loveTarget_c = gender_c;
                } else {
                    loveTarget_c = !gender_c;
                }
            } else {
                loveTarget_c = gender_c;
            }

            Human child = new Human(sex_c, gender_c, loveTarget_c);
            child.setPositionCenter(this, partner);

            return child;
        } else {
            return null;
        }
    }

    public void divorce(){
        this.isMarried = false;
        this.isAbleToReproduction = false;

        if(this.partner != null){
            // Human tmpPartner = this.partner;
            this.partner = null;
        }
    }

    public void updateVelocity(int leftW, int rightW, int lowerW, int upperW){
        if(this.partner != null){
            PVector force = new PVector(0,0);

            float dist = dist(this.position.x, this.position.y, this.partner.position.x, this.partner.position.y);

            force.x = (this.partner.position.x - this.position.x)/dist;
            force.y = (this.partner.position.y - this.position.y)/dist;
            
            force.x /= 2;
            force.y /= 2;

            this.velocity.x += force.x;
            this.velocity.y += force.y;
        }

        if(this.position.x < leftW || this.position.x > rightW){
            this.velocity.x *= -1;
        }
        if(this.position.y < lowerW || this.position.y > upperW){
            this.velocity.y *= -1;
        }
    }

    public void updatePosition(){
        this.position.x += this.velocity.x;
        this.position.y += this.velocity.y;
    }

    public void drawMe (){
        if(!this.isDead){
            if(this.sex == true){
                fill(0,0,255);
            } else{
                fill(255,0,0);
            }

            ellipse(this.position.x, this.position.y, 10, 10);

            if(this.partner != null){
                strokeWeight(0.1);
                stroke(0);
                line(this.position.x, this.position.y, this.partner.position.x, this.partner.position.y);
                noStroke();
            }
        }
    }


}
