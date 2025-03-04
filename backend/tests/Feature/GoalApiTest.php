<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Goal;

class GoalApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_can_fetch_all_goals()
    {
        Goal::insert([
            ['name' => 'Goal 1', 'targetPercentage' => 30],
            ['name' => 'Goal 2', 'targetPercentage' => 50],
            ['name' => 'Goal 3', 'targetPercentage' => 70],
        ]);

        $response = $this->getJson('/api/goals');
        $response->assertStatus(200)
                 ->assertJsonCount(3);
    }

    public function test_it_can_create_a_goal()
    {
        $data = [
            'name' => 'Unique Goal Name',
            'targetPercentage' => 60,
        ];

        $response = $this->postJson('/api/goals', $data);
        $response->assertStatus(201)
                 ->assertJson($data);

        $this->assertDatabaseHas('goals', $data);
    }

    public function test_it_cannot_create_duplicate_goal_name()
    {
        Goal::create(['name' => 'Duplicate Goal', 'targetPercentage' => 50]);
        
        $response = $this->postJson('/api/goals', [
            'name' => 'Duplicate Goal',
            'targetPercentage' => 60,
        ]);
        $response->assertStatus(422);
    }

    public function test_it_cannot_create_duplicate_goal_target_percentage()
    {
        Goal::create(['name' => 'Duplicate Goal', 'targetPercentage' => 50]);
        
        $response = $this->postJson('/api/goals', [
            'name' => 'New Goal Name',
            'targetPercentage' => 50,
        ]);
        $response->assertStatus(422);
    }

    public function test_it_cannot_create_goal_with_zero_percentage()
    {
        $response = $this->postJson('/api/goals', [
            'name' => 'New Goal Name',
            'targetPercentage' => 0,
        ]);
        $response->assertStatus(422);
    }

    public function test_it_cannot_create_goal_with_negative_percentage()
    {
        $response = $this->postJson('/api/goals', [
            'name' => 'New Goal Name',
            'targetPercentage' => -1,
        ]);
        $response->assertStatus(422);
    }

    public function test_it_cannot_create_goal_with_to_high_percentage()
    {
        $response = $this->postJson('/api/goals', [
            'name' => 'New Goal Name',
            'targetPercentage' => 101,
        ]);
        $response->assertStatus(422);
    }

    public function test_it_can_delete_a_goal()
    {
        $goal = Goal::create(['name' => 'Goal to Delete', 'targetPercentage' => 50]);

        $response = $this->deleteJson("/api/goals/{$goal->id}");
        $response->assertStatus(204);
        $this->assertDatabaseMissing('goals', ['id' => $goal->id]);
    }
}
