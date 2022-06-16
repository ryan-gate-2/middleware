<?php

namespace App\Http\Controllers\Slotlayer;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests; 
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Specialtactics\L5Api\Http\Controllers\RestfulController as BaseController;
use Illuminate\Http\Request;
use Validator;
use Illuminate\Support\Facades\Http;
use App\Models\Slotlayer\Gameoptions;
use App\Models\Slotlayer\CreateSessionErrors;
use App\Models\Slotlayer\DemoSessions;
use App\Models\Slotlayer\RegularSessions;
use App\Models\Slotlayer\AccessProfiles;
use App\Models\Slotlayer\GameoptionsParent;
use \Cache;
use Carbon\Carbon;
use DB;
use Illuminate\Support\Facades\Log;
use Dingo\Api\Routing\Helpers;
use Dingo\Api\Http\Response;
use Illuminate\Support\Facades\Crypt;
use Webpatser\Uuid\Uuid;

class DataController extends \App\Http\Controllers\Controller
{

	public function softswissHelper($softswiss, $type)
	{	
		if($type === 'full_id') {
			$explode = explode(':', $softswiss);
			$game_provider = $explode[0];
			$softswiss_id = $explode[1];
			if($game_provider === 'evoplay' && $softswiss_id !== NULL) {
				$return = 'evoplay/'.$softswiss_id;
			}
			else {
				$return = NULL; 
			}
		}

		if($type === 's1' || $type === 's2' || $type === 's3') {
				$return = 'https://cdn2.softswiss.net/i/'.$type.'/'.$softswiss.'.png';
		}

  		return $return;
	}

   /**
     * @param balance return to dk slotmachine
     * @return \Illuminate\Http\JsonResponse
     */
    public function gamesList(Request $request)
    {   
        $validator = Validator::make($request->all(), [
            'apikey' => ['required', 'min:12', 'max:155'],
            'show_provider' => ['required', 'min:2', 'max:35'],
        ]);

        $ip = $request->header('CF-Connecting-IP');


        if ($validator->stopOnFirstFailure()->fails()) {
            return response()->json(['status' => 400, 'error' => 'Validation of request form failed.', 'validation_messages' => $validator->errors(), 'request_ip' => $ip])->setStatusCode(400);
        }

        $selectParentApiSettings = GameoptionsParent::where('apikey_parent', $request->apikey)->first();
        $showProvider = $request->showProvider;


        if(!$selectParentApiSettings) {
            return response()->json([
                'status' => 401,
                'error' => 'Authorization error. Check if apikey is correct.',
                'request_ip' => $ip
            ])->setStatusCode(401);
        }

        $getAll = DB::table('gamelist')->get()->all();
  		
  		// Below should be cached in a seperate function at some point, but for now is fine, caching is pretty easy and is needed if using >2k~ games because you get idiot operators spamming the endpoint or for example using it directly to parse every time player visits their casino page.

  		// Example caching can be found on @AggregationController

  		foreach($getAll as $game) {

			$softswiss_cdn_s1 = NULL;
			$softswiss_cdn_s2 = NULL;
			$softswiss_cdn_s3 = NULL;
		  		
			if($game->softswiss !== NULL) {
				$game_softswiss_full = self::softswissHelper($game->game_provider.':'.$game->softswiss, 'full_id');

				if($game_softswiss_full) {
					$softswiss_cdn_s1 = self::softswissHelper($game_softswiss_full, 's1');
					$softswiss_cdn_s2 = self::softswissHelper($game_softswiss_full, 's2');
					$softswiss_cdn_s3 = self::softswissHelper($game_softswiss_full, 's3');
					
				}
			}

			$arrayGame[] = array(
			'game_id' => $game->game_id,
			'game_slug' => $game->game_slug,
			'game_desc' => $game->game_desc,
			'game_softswiss_id' => $game->softswiss,
			'game_softswiss_full' => $game_softswiss_full,
			'game_name' => $game->game_name,
			'game_provider' => $game->game_provider,
			'extra_id' => $game->extra_id,
			'demo_available' => $game->demo_mode,
			'disabled' => $game->disabled,
			'hidden' => $game->hidden,
			'api_ext' => $game->api_ext,
			'index_rating' => $game->index_rating,
			'type' => $game->api_ext,
			'parent_id' => $game->api_ext,
			'game_img' => 'https://cdn.betboi.io/square/evoplay/evo-y-budai-reels-bonus-buy.png?width=100',
			'game_img_s1' => $softswiss_cdn_s1,
			'game_img_s2' => $softswiss_cdn_s2,
			'game_img_s3' => $softswiss_cdn_s3,
			);
  		}




    	return $arrayGame;

    }



}