<?php
/**
 * @file
 * Handles the display/submission of the admin settings form for this module.
 */
/**
 * Defines the admin settings form.
 *
 * @param array $form
 *   The Drupal form definition.
 * @param array $form_state
 *   The Drupal form state.
 *
 * @return array
 *   The Drupal form definition.
 */
function ballads_viewer_admin(array $form, array &$form_state) {
  
  $form['ballads_viewer_linkxml'] = array(
    '#type' => 'checkbox',
    '#title' => t('Link to source'),
    '#description' => t('Link to the source XML.'),
    '#default_value' => variable_get('ballads_viewer_linkxml', TRUE),
  );
  
  $form['ballads_viewer_min_font_px'] = array(
	'#type' => 'textfield',
    '#size' => 20,
	'#default_value' => variable_get('ballads_viewer_min_font_px', '8.0'),
	'#description' => t('Minimum font size when rendering XML'),
	'#title' => 'Minimum font size',
  );
  
  $form['ballads_viewer_mmpx_ratio'] = array(
	'#type' => 'textfield',
    '#size' => 20,
	'#default_value' => variable_get('ballads_viewer_mmpx_ratio', '8.0'),
	'#description' => t('Pixes per millimeter when rendering XML.'),
	'#title' => 'MM/PX ratio'
  );
  
  $form['ballads_viewer_debug'] = array(
    '#type' => 'checkbox',
    '#title' => t('Debugging'),
    '#description' => t('Show error messages in the browser'),
    '#default_value' => variable_get('ballads_viewer_debug', FALSE),
  );
  
  return system_settings_form($form);
}