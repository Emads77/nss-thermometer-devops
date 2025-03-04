<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * @OA\Schema(
 *     schema="Goal",
 *     type="object",
 *     required={"name", "targetPercentage"},
 *     @OA\Property(property="name", type="string", description="The name of the goal"),
 *     @OA\Property(property="targetPercentage", type="integer", description="The target percentage of the goal"),
 * )
 */
class Goal extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'targetPercentage'];
}