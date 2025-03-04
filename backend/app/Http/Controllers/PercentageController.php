<?php

namespace App\Http\Controllers;

use App\Models\Percentage;
use Illuminate\Http\Request;

class PercentageController extends Controller
{
    /**
     * @OA\Get(
     *     path="/api/percentage",
     *     tags={"Percentage"},
     *     summary="Get the current percentage",
     *     @OA\Response(
     *         response=200,
     *         description="Successfully fetched percentage",
     *         @OA\JsonContent(type="object", @OA\Property(property="percentage", type="integer"))
     *     ),
     * )
     */
    public function index()
    {
        $percentage = Percentage::latest()->first();
        // When there is no percentage defined, return 0
        return response()->json(['percentage' => $percentage ? $percentage->percentage : 0]);
    }

    /**
     * @OA\Post(
     *     path="/api/percentage/{percentage}",
     *     tags={"Percentage"},
     *     summary="Update the percentage",
     *     @OA\Parameter(
     *         name="percentage",
     *         in="path",
     *         required=true,
     *         @OA\Schema(type="integer", example=50)
     *     ),
     *     @OA\Response(
     *         response=200,
     *         description="Successfully updated percentage"
     *     ),
     * )
     */
    public function store(Request $request, $percentage)
    {              
        if ($percentage < 0 || $percentage > 100) {
            return response()->json(['message' => 'Percentage must be between 0 and 100'], 422);
        }

        $percentageEntry = new Percentage();
        $percentageEntry->percentage = $percentage;
        $percentageEntry->save();

        return response()->json(['percentage' => $percentage], 200);
    }
}