int numOfHumans = 100;
float ratioOfMale = 0.5;
float ratioOfGIDisorder = 0.05;
float ratioOfHomosexual = 0.05;

int maxDistance = 40;
int minAge = 20;
int limitAge = 40;
float p_marry = 0.031;
float p_reproduction = 0.5;
int deathAge = 100;

int leftWall = 0;
int rightWall = 800;
int lowerWall = 0;
int upperWall = 450;

float ratioOfTransGender, ratioOfSameSexual;
float averageAge;
float ratioOfMarried;




ArrayList<Human> humans = new ArrayList<Human>();

void setup() {
    size(800, 450);
    frameRate(20);

    for(int i=0; i<numOfHumans; i++){
        Human newHuman = setupHumanSexuality();
        newHuman.setFirstPosition();
        humans.add(newHuman);

        // if(newHuman.sex != newHuman.gender){
        //     println(i + " is gay or lesbian.");
        // }
        // if(newHuman.gender == newHuman.loveTarget){
        //     println(i + " is transgender.");
        // }

        // println("sex: "+newHuman.sex);
        // println("gender: "+newHuman.gender);
        // println("loveTarget: "+newHuman.loveTarget);
    }
}

void draw() {
    background(255);
    noStroke();

    for(int i=0; i<humans.size(); i++){
        for(int j=i+1; j<humans.size(); j++){
            if(humans.get(i).isAbleToMarry && humans.get(j).isAbleToMarry && humans.get(i).checkDistance(humans.get(j), maxDistance) && humans.get(i).loveTarget==humans.get(j).gender && humans.get(j).loveTarget==humans.get(i).gender){
                float randomP = random(100) / 100;
                if(randomP < p_marry){
                    humans.get(i).marry(humans.get(j), limitAge);
                    humans.get(j).marry(humans.get(i), limitAge);
                    // println("========================================");
                    // println(i, j);
                    // println(humans.get(i).gender, humans.get(j).loveTarget);
                    // println(humans.get(j).gender, humans.get(i).loveTarget);
                    // println(humans.get(i).sex, humans.get(j).sex);
                    // println("========================================");
                }
            }
        }
    }

    for(int i=0; i<humans.size(); i++){
        humans.get(i).updateVelocity(leftWall, rightWall, lowerWall, upperWall);
        humans.get(i).updatePosition();
        humans.get(i).aging(limitAge);
        humans.get(i).checkAlive(deathAge);
        if(humans.get(i).isDead){
            humans.remove(humans.get(i));
            continue;
        }

        if(humans.get(i).isAbleToReproduction && humans.get(i).partner.isAbleToReproduction){
            float r = random(100)/100;
            if(r < p_reproduction){
                Human child = humans.get(i).reproduction(ratioOfGIDisorder, ratioOfHomosexual);
                humans.add(child);
            }
        }
        
        if(humans.get(i).age == minAge){
            humans.get(i).setToBeAbleToMarry();
        }

        if(humans.get(i).isDead && humans.get(i).isMarried){
            if(humans.get(i).partner != null){
                humans.get(i).partner.partner = null;
                humans.get(i).partner.setToBeAbleToMarry();            
                humans.get(i).partner = null;
            }
            // humans.get(i) = null;
        }
    }

    for(int i=0; i<humans.size(); i++){
        humans.get(i).drawMe();
    }
    // println(frameCount, humans.size());

    numOfHumans = humans.size();

    if(frameCount % int(frameRate*0.5) ==0){
        if(numOfHumans != 0){
            for(int i=0; i<humans.size(); i++){
                Human human_i = humans.get(i);

                if(human_i.sex != human_i.gender){
                    ratioOfTransGender ++;
                }
                if(human_i.gender == human_i.loveTarget){
                    ratioOfSameSexual ++;
                }
                if(human_i.isMarried){
                    ratioOfMarried ++;
                }
                averageAge += human_i.age;
            }
            ratioOfTransGender /= numOfHumans;
            ratioOfSameSexual /= numOfHumans;
            ratioOfMarried /= numOfHumans;
            averageAge /= numOfHumans;
        } else {
            ratioOfTransGender = 0;
            ratioOfSameSexual = 0;
            ratioOfMarried = 0;
            averageAge = 0;
        }

        println("Population: "+ numOfHumans);
        println("Average Age: "+ averageAge);
        println("Ratio of Married: "+ ratioOfMarried);
        println("Ratio of GI Disorder: "+ ratioOfTransGender);
        println("Ratio of Lesbian and Gay: "+ ratioOfSameSexual);
        println("================================================");
    }

}

Human setupHumanSexuality(){

    boolean sex, gender, loveTarget;
    double randomValue = random(100) / 100;
    if(randomValue < ratioOfMale){
        sex = false;
    }else{
        sex = true;
    }
    randomValue = random(100) / 100;
    if(randomValue < ratioOfGIDisorder){
        gender = !sex;
    }else{
        gender = sex;
    }
    randomValue = random(100) / 100;
    if(randomValue < ratioOfHomosexual){
        loveTarget = gender;
    }else{
        loveTarget = !gender;
    }

    Human human = new Human(sex, gender, loveTarget);
    return human;
}