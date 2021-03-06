#ifndef MOVER_HPP
#define MOVER_HPP

#include "GameObject.hpp"

class Rail;
class World;

enum MoverType {
	MT_MAGNET = 1,
	MT_SPRING = 2,
	MT_STATIC = 3
};

class Mover : public GameObject {
public:
	Mover();

	virtual void Initialize(World& world);
	virtual void InitializePhysics();

	virtual void Update(float time_delta);
	virtual void Draw(sf::RenderTarget* target, sf::Shader& shader, bool editor_mode = false) const;

	void SetRail(Rail* rail);

	virtual bool OnCollide(GameObject* other);

	std::string ToString();

	void SetMoverType(MoverType type);
	MoverType GetMoverType() const;

	void ToggleMoverType();
private:
	Rail* mRail;
	sf::Sprite mSprite;
	MoverType mType;
};

#endif // MOVER_HPP
