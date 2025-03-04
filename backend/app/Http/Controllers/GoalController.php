<?php

namespace App\Http\Controllers;

use App\Models\Goal;
use Illuminate\Http\Request;

/**
 * @OA\Info(
 *     title="NSE Thermometer API",
 *     version="1.0.0",
 *     description="These are all the routings for the application.",
 *     @OA\Contact(
 *         email="e.f.duipmans@saxion.nl"
 *     )
 * )
 */
class GoalController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/goals",
     *     tags={"Goals"},
     *     summary="Fetch all goals",
     *     @OA\Response(
     *         response=200,
     *         description="Successfully fetched goals",
     *         @OA\JsonContent(type="array", @OA\Items(ref="#/components/schemas/Goal"))
     *     ),
     * )
     */
    public function index()
    {
        $goals = Goal::orderBy('targetPercentage', 'asc')->get();
        return response()->json($goals);
    }

    /**
     * @OA\Post(
     *     path="/api/goals",
     *     tags={"Goals"},
     *     summary="Create a new goal",
     *     description="This endpoint allows you to create a new goal. The goal's name and target percentage must be unique.",
     *     @OA\RequestBody(
     *         required=true,
     *         @OA\JsonContent(
     *             type="object",
     *             @OA\Property(property="name", type="string", description="The name of the goal", example="Docenten bakken taart voor studenten."),
     *             @OA\Property(property="targetPercentage", type="integer", description="The target percentage for the goal (0 to 100)", example=55)
     *         )
     *     ),
     *     @OA\Response(
     *         response=201,
     *         description="Successfully created the goal",
     *         @OA\JsonContent(
     *             @OA\Property(property="id", type="integer", description="The ID of the newly created goal", example=1),
     *             @OA\Property(property="name", type="string", description="The name of the goal", example="Docenten bakken taart voor studenten."),
     *             @OA\Property(property="targetPercentage", type="integer", description="The target percentage for the goal", example=55)
     *         )
     *     ),
     *     @OA\Response(
     *         response=400,
     *         description="Validation error. The name and target percentage must be unique.",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="The name and targetPercentage must be unique.")
     *         )
     *     ),
     *     @OA\Response(
     *         response=422,
     *         description="Unprocessable Entity. Validation errors occurred.",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="The name has already been taken."),
     *             @OA\Property(property="errors", type="object", additionalProperties={
     *                 @OA\Property(property="name", type="array", @OA\Items(type="string", example="The name has already been taken.")),
     *                 @OA\Property(property="targetPercentage", type="array", @OA\Items(type="string", example="The target percentage must be unique."))
     *             })
     *         )
     *     )
     * )
     */
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|unique:goals,name',
            'targetPercentage' => 'required|integer|unique:goals,targetPercentage|between:1,100',
        ]);

        $goal = Goal::create($request->all());
        return response()->json($goal, 201);
    }
    
    /**
     * @OA\Delete(
     *     path="/api/goals/{id}",
     *     tags={"Goals"},
     *     summary="Delete a goal by ID",
     *     @OA\Parameter(
     *         name="id",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer", example=1)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully deleted the goal",
     *         @OA\JsonContent(
     *             @OA\Property(property="message", type="string", example="Goal deleted successfully")
     *         )
     *     ),
     *     @OA\Response(
     *         response=404,
     *         description="Goal not found"
     *     )
     * )
     */
    public function destroy($id)
    {
        $goal = Goal::findOrFail($id);
        $goal->delete();
        return response()->json(null, 204);
    }
}