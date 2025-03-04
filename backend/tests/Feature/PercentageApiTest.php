<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;
use App\Models\Percentage;

class PercentageApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_it_returns_the_latest_percentage()
    {
        Percentage::insert([
            ['percentage' => 40, 'created_at' => now()->subMinutes(10)],
            ['percentage' => 60, 'created_at' => now()],
        ]);

        $response = $this->getJson('/api/percentage');
        $response->assertStatus(200)
                 ->assertJson(['percentage' => 60]);
    }

    public function test_it_returns_zero_if_no_percentages_exist()
    {
        $response = $this->getJson('/api/percentage');
        $response->assertStatus(200)
                 ->assertJson(['percentage' => 0]);
    }

    public function test_it_can_set_a_new_percentage()
    {
        $response = $this->postJson('/api/percentage/45');
        $response->assertStatus(200)
                 ->assertJson(['percentage' => 45]);
        $this->assertDatabaseHas('percentages', ['percentage' => 45]);
    }

    public function test_it_rejects_invalid_percentages_to_low()
    {
        $response = $this->postJson('/api/percentage/-1');
        $response->assertStatus(422);
    }

    public function test_it_rejects_invalid_percentages_to_high()
    {
        $response = $this->postJson('/api/percentage/101');
        $response->assertStatus(422);
    }
}
